import re
import os, datetime
from flask.helpers import jsonify
from flask_mongokit import BSONObjectIdConverter
from flask import Flask, request, session, g, redirect, url_for, abort, render_template, flash
from flaskext.mongoengine import MongoEngine
from flaskext.mongoengine.wtf import model_form
from flaskext.wtf import Form, SelectField, IntegerField, PasswordField, SubmitField
from flask.wrappers import Response
from flask_debugtoolbar import DebugToolbarExtension
from werkzeug.datastructures import MultiDict
from werkzeug.utils import secure_filename
from wtforms.fields import TextField
from wtforms.validators import ValidationError, Required
from serializers import mongo_jsonify
from utils import xlsx_importer, allowed_file, EmailOrBlank, DateTimeField

app = Flask(__name__)
app.config.from_pyfile('config.py')
app.url_map.converters['ObjectId'] = BSONObjectIdConverter
db = MongoEngine(app)
toolbar = DebugToolbarExtension(app)

USERNAME, PASSWORD = 'admin', 'default'

# documents
class Phone(db.EmbeddedDocument):
    type = db.StringField(required=True, default='home')
    number = db.StringField(required=True)
    stats = db.MapField(db.IntField(), default=dict(s=0, m=0, n=0, d=0))


class Contact(db.EmbeddedDocument):
    first_name = db.StringField(required=True)
    last_name = db.StringField(required=True)
    email = db.EmailField()
    relationship = db.StringField()
    is_guardian = db.BooleanField(default=False)
    phones = db.ListField(db.EmbeddedDocumentField(Phone))


class StudentStats(db.EmbeddedDocument):
    count = db.IntField(default=0)
    charge = db.MapField(db.IntField(), default=dict(p=0, n=0))
    last_contact = db.DateTimeField()


class Student(db.Document):
    first_name = db.StringField(required=True)
    last_name = db.StringField(required=True)
    contacts = db.ListField(db.EmbeddedDocumentField(Contact))
    groups = db.ListField(db.StringField())
    stats = db.EmbeddedDocumentField(StudentStats, default=StudentStats())


class CallLogEntry(db.Document):
    """call log entries reference the student and the phone.
    since contacts come and go, we could do periodic cleaning of non-associated records"""
    phone = db.StringField(required=True)
    student = db.StringField(required=True)
    charge = db.IntField(required=True)
    status = db.IntField(required=True)
    created_on = db.DateTimeField(default=datetime.datetime.now, required=True)
    attempted_on = db.DateTimeField()
    completed_on = db.DateTimeField()


# import forms
PhoneImportForm = model_form(Phone, exclude=('stats',))
ContactImportForm = model_form(Contact, exclude=('phones',), field_args={
    'email': {'validators': [EmailOrBlank()]}})
StudentForm = model_form(Student, exclude=('contacts', 'stats',))

# frontend forms
class CallLogEntryForm(Form):
    student_id = TextField(u'Student id', validators=[Required()])
    number = TextField(u'Phone number', validators=[Required()])
    charge = SelectField(u'Intent',
        choices=[(0, u'Negative'), (1, u'Positive')], validators=[Required()])
    status = SelectField(u'Status', choices=[
        (200, u'Success'), (300, u'Message'), (400, u'Kept Ringing'),
        (500, u'Dropped')], validators=[Required()])
    created_on = DateTimeField(u'Created on', validators=[Required()])
    attempted_on = DateTimeField(u'Attempted on')
    completed_on = DateTimeField(u'Completed on')
    submit = SubmitField(u'Save')


class LoginForm(Form):
    username, password = TextField(u'Username'), PasswordField(u'Password')
    submit = SubmitField(u'Login')

    def validate_username(self, field):
        if field.data != USERNAME:
            raise ValidationError, "Invalid username"

    def validate_password(self, field):
        if field.data != PASSWORD:
            raise ValidationError, "Invalid password"


# views
@app.route('/')
def index():
    return render_template("index.html")


@app.route('/student/<ObjectId:student_id>', methods=['GET', 'POST'])
def show_student(student_id):
    form = ContactForm()
    if request.method == 'POST':
        if form.validate_on_submit():
            contact = Contact()
            form.populate_obj(contact)
            contact.student_id = student_id
            db.session.add(contact)
            db.session.commit()
            flash('New contact added')
            return redirect(url_for('show_student', student_id=student_id))
        else:
            flash('Form errors')
    return render_template('show_student.html',
        student=Student.objects(id=student_id).first_or_404(), form=form)


@app.route('/class', methods=['GET', 'POST'])
def show_class():
    form = StudentForm()
    if request.method == 'POST':
        if form.validate_on_submit():
            student = Student()
            form.populate_obj(student)
            db.session.add(student)
            db.session.commit()
            flash('New student added')
            return redirect(url_for('show_class'))
        else:
            flash('Form errors')
    return render_template('show_class.html', students=Student.objects,
        form=form)


@app.route('/add_clog_entry', methods=['GET', 'POST'])
def add_clog_entry():
    form = CallLogEntryForm()
    return render_template('post_log.html', form=form)


@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        session['logged_in'] = True
        flash('You were logged in')
        return redirect(url_for('show_class'))
    return render_template('login.html', form=form)


@app.route('/logout')
def logout():
    session.pop('logged_in', None)
    flash('You were logged out')
    return redirect(url_for('index'))


@app.route('/', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        file = request.files['file']
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            file.save(filepath)
            for student_record in xlsx_importer(filepath):
                student_from_dict(student_record)
            flash('Your file has been imported')
            return redirect(url_for('show_class'))
    flash('Something went south with your upload')
    return redirect(url_for('show_class'))


def student_from_dict(student_record_dict, full_only=True,
                      safe_phone_numbers=True):
    # process the student record
    student_form = StudentForm(formdata=MultiDict(student_record_dict),
        csrf_enabled=False)
    if student_form.validate():
        student = Student()
        student_form.populate_obj(student)
        # process the nested contact record
        for contact_record in student_record_dict['contacts']:
            contact_form = ContactImportForm(formdata=MultiDict(contact_record)
                , csrf_enabled=False)
            if contact_form.validate():
                contact = Contact()
                contact_form.populate_obj(contact)
                # process the nested phone record
                for phone_record in contact_record['phones']:
                    phone_form = PhoneImportForm(
                        formdata=MultiDict(phone_record), csrf_enabled=False)
                    if phone_form.validate():
                        phone = Phone()
                        phone_form.populate_obj(phone)
                        phone.number = unicode(phone.number) # FIXME hacked up
                        # sanitize phone numbers (testing)
                        if safe_phone_numbers:
                            phone.number = re.sub('[0-9]', '5', phone.number,
                                3)
                        contact.phones.append(phone)
                    else:
                        app.logger.debug(phone_form.errors)
                    # if not full-only or contact has at least one phone, add the contact
                if not full_only or len(contact.phones) > 0:
                    student.contacts.append(contact)
            else:
                app.logger.debug(contact_form.errors)
            # if not full-only or student has at least one contact, add the student
        if not full_only or len(student.contacts) > 0:
            student.save()
    else:
        app.logger.debug(student_form.errors)

# api
@app.route('/api/v1/student')
def student_resource():
    return mongo_jsonify(results=Student.objects)


@app.route('/api/v1/clog_entry', methods=['POST'])
def call_log_entry_resource():
    params = request.json
    form = CallLogEntryForm(csrf_enabled=False, formdata=MultiDict(params))
    if form.validate():
        call_log_entry = CallLogEntry()
        form.populate_obj(call_log_entry)
        call_log_entry.save()
        return Response('CREATED', status=201)
    else:
        return Response(jsonify(form.errors), status=400)


@app.route('/api/v1/clog/', methods=['GET'])
def call_log_resource():
    student_id = request.args.get('student_id')
    if not student_id:
        abort(400)

    return mongo_jsonify(results=CallLogEntry.objects)

# main function
if __name__ == '__main__':
    app.run(host='0.0.0.0')
