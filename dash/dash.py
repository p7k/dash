import os, datetime
from flask import Flask, request, session, g, redirect, url_for, abort, render_template, flash
from flaskext.mongoengine import MongoEngine
from flaskext.wtf import Form, DateTimeField, SelectField, IntegerField, TextField, PasswordField, SubmitField
from flaskext.wtf import Email, Required, Length, ValidationError
from flask.helpers import jsonify
from flask.wrappers import Response
from flask_debugtoolbar import DebugToolbarExtension
from werkzeug.datastructures import MultiDict
from werkzeug.utils import secure_filename

app = Flask(__name__)
app.config.from_pyfile('config.py')
db = MongoEngine(app)
toolbar = DebugToolbarExtension(app)

DT_FORMAT = r'%Y-%m-%d %H:%M:%S'

# models
#class Student(db.Model):
#    id = db.Column(db.Integer, primary_key=True)
#    first_name = db.Column(db.Unicode(20), nullable=False)
#    last_name = db.Column(db.Unicode(20), nullable=False)
#    contacts = db.relationship('Contact', backref='student')
#
#    def to_dict(self):
#        return dict(id=self.id, first_name=self.first_name, last_name=self.last_name,
#            contacts=[contact.to_dict() for contact in self.contacts])
#
#
#class Contact(db.Model):
#    id = db.Column(db.Integer, primary_key=True)
#    first_name = db.Column(db.Unicode(20), nullable=False)
#    last_name = db.Column(db.Unicode(20), nullable=False)
#    email = db.Column(db.Unicode(200))
#    phone = db.Column(db.Unicode(20), nullable=False)
#    relationship = db.Column(db.Unicode(20), nullable=False)
#    student_id = db.Column(db.Integer, db.ForeignKey('student.id'))
#    call_log_entries = db.relationship('CallLogEntry', backref='call_log_entries')
#
#    def to_dict(self):
#        return dict(id=self.id, first_name=self.first_name, last_name=self.last_name, phone=self.phone,
#            relationship=self.relationship, email=self.email)
#
#
#class CallLogEntry(db.Model):
#    id = db.Column(db.Integer, primary_key=True)
#    contact_id = db.Column(db.Integer, db.ForeignKey('contact.id'))
#    intent = db.Column(db.Integer(3), nullable=False)
#    created_on = db.Column(db.DateTime, default=datetime.datetime.now, nullable=False)
#    attempted_on = db.Column(db.DateTime(), nullable=False)
#    completed_on = db.Column(db.DateTime(), nullable=False)
#    status = db.Column(db.Integer(3), nullable=False)
#
#    def to_dict(self):
#        return dict(contact_id=self.contact_id, intent=self.intent, created_on=self.created_on.strftime(DT_FORMAT),
#            attempted_on=self.attempted_on.strftime(DT_FORMAT), completed_on=self.completed_on.strftime(DT_FORMAT),
#            status=self.status)


# forms
class StudentForm(Form):
    first_name = TextField(u'First name', validators=[Required(), Length(min=2, max=20)])
    last_name = TextField(u'Last name', validators=[Required(), Length(min=2, max=20)])
    submit = SubmitField(u'Save')


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

@app.route('/student/<int:student_id>', methods=['GET', 'POST'])
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
    student = Student.query.filter_by(id=student_id).first_or_404()
    return render_template('show_student.html', student=student, form=form)

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
    students = Student.query.all()
    return render_template('show_class.html', students=students, form=form)

@app.route('/api/v1/student')
def student_resource():
    students = Student.query.all()
    return jsonify(results=[student.to_dict() for student in students])

@app.route('/add_clog_entry', methods=['GET', 'POST'])
def add_clog_entry():
    form = CallLogEntryForm()
    return render_template('post_log.html', form=form)

@app.route('/api/v1/clog_entry', methods=['POST'])
def call_log_entry_resource():
    params = request.json
    form = CallLogEntryForm(csrf_enabled=False, formdata=MultiDict(params))
    if form.validate():
        call_log_entry = CallLogEntry()
        form.populate_obj(call_log_entry)
        db.session.add(call_log_entry)
        db.session.commit()
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

if __name__ == '__main__':
    app.run(host='0.0.0.0')
