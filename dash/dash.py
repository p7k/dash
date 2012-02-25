from flask.helpers import jsonify
from flask_mongokit import BSONObjectIdConverter
import os, datetime
from flask import Flask, request, session, g, redirect, url_for, abort, render_template, flash
from flaskext.mongoengine import MongoEngine
from flaskext.mongoengine.wtf import model_form
from flaskext.wtf import Form, DateTimeField, SelectField, IntegerField, TextField, PasswordField, SubmitField
from flaskext.wtf import Email, Required, Length, ValidationError
from flask.wrappers import Response
from flask_debugtoolbar import DebugToolbarExtension
from werkzeug.datastructures import MultiDict
from werkzeug.utils import secure_filename
from serializers import mongo_jsonify, DT_FORMAT

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
    stats = db.MapField(db.IntField(), default={'200': 0, '300': 0, '400': 0, '500': 0})

class Contact(db.EmbeddedDocument):
    first_name = db.StringField(required=True)
    last_name = db.StringField(required=True)
    email = db.EmailField()
    relationship = db.StringField()
    phones = db.ListField(db.EmbeddedDocumentField(Phone))

class Student(db.Document):
    first_name = db.StringField(required=True)
    last_name = db.StringField(required=True)
    contacts = db.ListField(db.EmbeddedDocumentField(Contact))
    groups = db.ListField(db.StringField())

class CallLogEntry(db.Document):
    _id = db.StringField(required=True)
    intent = db.IntField(required=True)
    created_on = db.DateTimeField(default=datetime.datetime.now, required=True)
    attempted_on = db.DateTimeField(required=True)
    completed_on = db.DateTimeField(required=True)
    status = db.IntField(required=False)

# forms
StudentForm = model_form(Student)

class ContactForm(Form):
    first_name = TextField(u'First name', validators=[Required(), Length(min=2, max=20)])
    last_name = TextField(u'Last name', validators=[Required(), Length(min=2, max=20)])
    email = TextField(u'Email', validators=[Email()])
    phone = TextField(u'Phone', validators=[Required()])
    relationship = TextField(u'Relationship', validators=[Required()])
    submit = SubmitField(u'Save')

class CallLogEntryForm(Form):
    contact_id = IntegerField(u'Contact id', validators=[Required()])
    intent = SelectField(u'Intent', choices=[(u'0', 0), (u'1', 1), (u'2', 2)], validators=[Required()])
    created_on = DateTimeField(u'Created on', format=DT_FORMAT, validators=[Required()])
    attempted_on = DateTimeField(u'Attempted on', format=DT_FORMAT, validators=[Required()])
    completed_on = DateTimeField(u'Completed on', format=DT_FORMAT, validators=[Required()])
    status = SelectField(u'Status', choices=[(u'200', 200), (u'200', 300), (u'400', 400), (u'500', 500)], validators=[Required()])
    submit = SubmitField(u'Save')

class LoginForm(Form):
    username = TextField(u'Username')
    password = PasswordField(u'Password')
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
    return render_template('show_student.html', student=Student.objects(id=student_id).first_or_404(), form=form)

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
    return render_template('show_class.html', students=Student.objects, form=form)

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
    from utils import allowed_file, xlsx_import
    if request.method == 'POST':
        file = request.files['file']
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            file.save(filepath)
            xlsx_import(filepath)
            flash('Your file has been imported')
            return redirect(url_for('show_class'))
    flash('Something went south with your upload')
    return redirect(url_for('show_class'))

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

@app.route('/api/v1/clog', methods=['GET', 'POST'])
def call_log_resource():
    student_id = request.args.get('student_id')
    if not student_id:
        abort(400)
    student = Student.query.filter_by(id=student_id).first()
    if not student:
        abort(400)
    call_log_entries = db.session.query(CallLogEntry).select_from(Contact).join(Contact.call_log_entries)\
        .filter(Contact.id.in_([c.id for c in student.contacts]))
    return jsonify(results=[call_log_entry.to_dict() for call_log_entry in call_log_entries])

if __name__ == '__main__':
    app.run(host='0.0.0.0')
