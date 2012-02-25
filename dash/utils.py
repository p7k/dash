import datetime
import re
from werkzeug.datastructures import MultiDict
from wtforms.fields import TextField
from config import ALLOWED_EXTENSIONS
from dash import db, app, StudentForm, ContactForm

def gen_fixtures():
    student1 = Student(first_name='John', last_name='Doe', contacts=[
        Contact(first_name='Foo', last_name='Doe', phone='555-123-4567', email='foo.doe@example.com', relationship='dad'),
        Contact(first_name='Bar', last_name='Doe', phone='555-321-7654', email='bar.doe@example.com', relationship='mom'),
        ])
    contact_with_log = Contact(first_name='Dash', last_name='Smith', phone='555-123-4567',
        email='dash.smith@example.com', relationship='dad', call_log_entries=[
            CallLogEntry(intent=0, attempted_on=datetime.datetime.now(), completed_on=datetime.datetime.now(), status=200),
            CallLogEntry(intent=1, attempted_on=datetime.datetime.now(), completed_on=datetime.datetime.now(), status=300),
            CallLogEntry(intent=0, attempted_on=datetime.datetime.now(), completed_on=datetime.datetime.now(), status=400),
            CallLogEntry(intent=1, attempted_on=datetime.datetime.now(), completed_on=datetime.datetime.now(), status=500)])
    student2 = Student(first_name='Jane', last_name='Smith', contacts=[contact_with_log,
                                                                       Contact(first_name='Rules', last_name='Smith', phone='555-321-7654', email='rules.smith@example.com',
                                                                           relationship='mom')])
    db.session.add(student1)
    db.session.add(student2)
    db.session.commit()

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS

def xlsx_import(filename, safe_phone=True):
    from openpyxl.reader.excel import load_workbook

    wb = load_workbook(filename)
    ws = wb.worksheets[0]

    def split_fullname(fullname):
        res = dict(last_name='', first_name='')
        if not fullname:
            return res
        splits = fullname.split(',')
        if len(splits) < 2:
            return res
        return dict(zip(['last_name', 'first_name'], [name.strip() for name in fullname.split(',')]))

    headers = [c.value for c in ws.rows[0]]
    for row in ws.rows[1:]:
        record = dict(zip(headers, [c.value for c in row]))
        student = dict(first_name=record['First Name'], last_name=record['Last Name'])
        father_home = dict(phone=record['Father Home Phone'], email=record['Fatheremail'], relationship='Father', **split_fullname(record['Father']))
        father_cell = dict(phone=record['Fathercellphone'], email=record['Fatheremail'], relationship='Father', **split_fullname(record['Father']))
        father_day = dict(phone=record['Fatherdayphone'], email=record['Fatheremail'], relationship='Father', **split_fullname(record['Father']))
        mother_home = dict(phone=record['Mother Home Phone'], email=record['Motheremail'], relationship='Mother', **split_fullname(record['Mother']))
        mother_cell = dict(phone=record['Mothercellphone'], email=record['Motheremail'], relationship='Mother', **split_fullname(record['Mother']))
        mother_day = dict(phone=record['Motherdayphone'], email=record['Motheremail'], relationship='Mother', **split_fullname(record['Mother']))

        class RelaxedContactForm(ContactForm):
            email = TextField(u'Email')

        with app.test_request_context():
            sf = StudentForm(formdata=MultiDict(student), csrf_enabled=False)
            if sf.validate():
                s = Student()
                sf.populate_obj(s)
                for contact in [father_home, father_cell, father_day, mother_home, mother_cell, mother_day]:
                    cf = RelaxedContactForm(formdata=MultiDict(contact), csrf_enabled=False)
                    if cf.validate():
                        c = Contact()
                        cf.populate_obj(c)
                        if safe_phone:
                            if isinstance(c.phone, basestring):
                                c.phone = re.sub(r'[0-9]', '5', c.phone, 3)
                        s.contacts.append(c)
                    else:
                        app.logger.debug(cf.errors)
                if len(s.contacts) > 0:
                    db.session.add(s)
                    db.session.commit()

