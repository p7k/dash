import os

DEBUG = False
SQLALCHEMY_DATABASE_URI = 'sqlite:///dash.db'
SQLALCHEMY_ECHO = DEBUG
SECRET_KEY = 'development key'
USERNAME = 'admin'
PASSWORD = 'default'
UPLOAD_FOLDER = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'uploads')
ALLOWED_EXTENSIONS = {'xlsx'}

# local configuration overrides
try:
    from config_local import *
except ImportError:
    pass
