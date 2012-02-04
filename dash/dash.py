# -*- coding: utf-8 -*-
"""
    Dash
    ~~~~~~
"""
from flask import Flask, request, session, g, redirect, url_for, abort, render_template, flash
from flaskext.wtf import Form, TextField, PasswordField, SubmitField, Email, Required, Length, ValidationError
from flaskext.sqlalchemy import SQLAlchemy
from flask.helpers import jsonify

# configuration
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

# models
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
    email = db.Column(db.Unicode(40))
    phone = db.Column(db.Unicode(20))
    relationship = db.Column(db.Unicode(20))
    student_id = db.Column(db.Integer, db.ForeignKey('student.id'))

    def to_dict(self):
        return dict(id=self.id, first_name=self.first_name, last_name=self.last_name, phone=self.phone,
            relationship=self.relationship)

db.create_all()


# forms
class StudentForm(Form):
    first_name = TextField("First name", validators=[Required(), Length(min=2, max=20)])
    last_name = TextField("Last name", validators=[Required(), Length(min=2, max=20)])
    submit = SubmitField("Save")


class ContactForm(Form):
    first_name = TextField("First name", validators=[Required(), Length(min=2, max=20)])
    last_name = TextField("Last name", validators=[Required(), Length(min=2, max=20)])
    email = TextField('Email', validators=[Email()])
    phone = TextField('Phone', validators=[Required()])
    submit = SubmitField("Save")


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


# views
@app.route('/student/<int:student_id>', methods=['GET', 'POST'])
def show_student(student_id):
    if not session.get('logged_in'):
        abort(401)

    form = ContactForm()
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


@app.route('/', methods=['GET', 'POST'])
def show_class():
    form = StudentForm()
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
    app.run(host='0.0.0.0')
