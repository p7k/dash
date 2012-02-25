import os

DEBUG = False
MONGODB_DB = 'dash'
SQLALCHEMY_DATABASE_URI = 'sqlite:///dash.db'
SQLALCHEMY_ECHO = DEBUG
SECRET_KEY = 'development key'
UPLOAD_FOLDER = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'uploads')

# local configuration overrides
try:
    from config_local import *
except ImportError:
    pass
