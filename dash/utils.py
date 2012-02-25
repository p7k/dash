import re
from werkzeug.datastructures import MultiDict
from wtforms.fields import TextField
from openpyxl.reader.excel import load_workbook
from dash import db, app, StudentForm, ContactForm, Contact, Student

ALLOWED_EXTENSIONS = {'xlsx'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS

def split_fullname(fullname):
    res = dict(last_name='', first_name='')
    if not fullname:
        return res
    splits = fullname.split(',')
    if len(splits) < 2:
        return res
    return dict(zip(['last_name', 'first_name'], [name.strip() for name in fullname.split(',')]))

def xlsx_import(filename, safe_phone=True):

    wb = load_workbook(filename)
    ws = wb.worksheets[0]

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
