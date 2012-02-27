import re
from openpyxl.reader.excel import load_workbook
from wtforms.validators import Email, ValidationError, StopValidation

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

def xlsx_importer(filename):
    wb = load_workbook(filename)
    ws = wb.worksheets[0]

    headers = [c.value for c in ws.rows[0]]
    for row in ws.rows[1:]:
        record = dict(zip(headers, [c.value for c in row]))
        yield dict(first_name=record['First Name'], last_name=record['Last Name'], contacts=[
           dict(relationship='father', email=record['Fatheremail'], phones=[
               dict(number=record['Father Home Phone'], type='home'),
               dict(number=record['Fathercellphone'], type='cell'),
               dict(number=record['Fatherdayphone'], type='day')
           ], **split_fullname(record['Father'])),
           dict(relationship='mother', email=record['Motheremail'], phones=[
               dict(number=record['Mother Home Phone'], type='home'),
               dict(number=record['Mothercellphone'], type='cell'),
               dict(number=record['Motherdayphone'], type='day')
           ], **split_fullname(record['Mother'])),
        ])

class EmailOrBlank(Email):
    def __call__(self, form, field):
        try:
            super(Email, self).__call__(form, field)
        except ValidationError:
            field.data = None
            raise StopValidation()
