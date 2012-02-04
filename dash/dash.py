# -*- coding: utf-8 -*-
"""
    Dash
    ~~~~~~
"""
from __future__ import with_statement
from flask import Flask, request, session, g, redirect, url_for, abort, \
     render_template, flash
from flaskext.wtf import Form, TextField, TextAreaField, \
    PasswordField, SubmitField, Required, ValidationError
from flaskext.sqlalchemy import SQLAlchemy

# configuration
from flask.helpers import jsonify

DEBUG = True
SQLALCHEMY_DATABASE_URI = 'sqlite:///dash.db'
SQLALCHEMY_ECHO = DEBUG
SECRET_KEY = 'development key'
USERNAME = 'admin'
PASSWORD = 'default'

# create our little application :)
app = Flask(__name__)
app.config.from_object(__name__)
db = SQLAlchemy(app)

class Entry(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.Unicode(200))
    text = db.Column(db.UnicodeText)

class Student(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.Unicode(20))
    last_name = db.Column(db.Unicode(20))
    contacts = db.relationship('Contact', backref='student')

    def to_dict(self):
        return dict(id=self.id, first_name=self.first_name, last_name=self.last_name,
            contacts=[contact.to_dict() for contact in self.contacts])

class Contact(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.Unicode(20))
    last_name = db.Column(db.Unicode(20))
    phone = db.Column(db.Unicode(20))
    relationship = db.Column(db.Unicode(20))
    student_id = db.Column(db.Integer, db.ForeignKey('student.id'))

    def to_dict(self):
        return dict(id=self.id, first_name=self.first_name, last_name=self.last_name, phone=self.phone,
            relationship=self.relationship)

db.create_all()

class StudentForm(Form):
    first_name = TextField("First name", validators=[Required()])
    last_name = TextField("Last name", validators=[Required()])
    submit = SubmitField("Save")

class ContactForm(Form):
    first_name = TextField("First name", validators=[Required()])
    last_name = TextField("Last name", validators=[Required()])
    phone = TextField('Phone', validators=[Required()])
    submit = SubmitField("Save")

#pasha = Student(first_name='Pavel', last_name='Katsev')
#dad = Contact(first_name='Gregory', last_name='Katsev', phone='415-734-1193')

class EntryForm(Form):
    title = TextField("Title", validators=[Required()])
    text = TextAreaField("Text")
    submit = SubmitField("Share")

class LoginForm(Form):
    username = TextField("Username")
    password = PasswordField("Password")
    submit = SubmitField("Login")
    
    def validate_username(self, field):
        if field.data != USERNAME:
            raise ValidationError, "Invalid username"

    def validate_password(self, field):
        if field.data != PASSWORD:
            raise ValidationError, "Invalid password"


@app.route('/student/<int:student_id>', methods=['GET', 'POST'])
def student_details(student_id):
    if not session.get('logged_in'):
        abort(401)

    form = ContactForm()
    if request.method == 'POST':
        contact = Contact()
        form.populate_obj(contact)
        contact.student_id = student_id
        db.session.add(contact)
        db.session.commit()
        flash('New contact added')

    student = Student.query.filter_by(id=student_id).first_or_404()
    return render_template('student_details.html', student=student, form=form)

@app.route('/api/v1/student')
def student_resource():
    students = Student.query.all()
    return jsonify(results=[student.to_dict() for student in students])

@app.route('/')
def show_students():
    students = Student.query.all()
    form = StudentForm()
    return render_template('show_students.html', students=students, form=form)


@app.route('/add', methods=['POST'])
def add_student():
    if not session.get('logged_in'):
        abort(401)

    form = StudentForm()
    if form.validate():
        student = Student()
        form.populate_obj(student)
        db.session.add(student)
        db.session.commit()
        flash('Student added')
    else:
        flash("Your form contained errors")

    return redirect(url_for('show_students'))


@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        session['logged_in'] = True
        flash('You were logged in')
        return redirect(url_for('show_entries'))
    return render_template('login.html', form=form)


@app.route('/logout')
def logout():
    session.pop('logged_in', None)
    flash('You were logged out')
    return redirect(url_for('show_entries'))


if __name__ == '__main__':
    db.create_all()
    app.run()
