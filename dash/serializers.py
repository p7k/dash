import datetime
from itertools import groupby
import mongoengine
from pymongo.dbref import DBRef
from pymongo.objectid import ObjectId
from flask.helpers import json, _assert_have_json
from flask.globals import current_app, request
import types

DT_FORMAT = r'%Y-%m-%d %H:%M:%S'

class MongoEngineEncoder(json.JSONEncoder):
    def default(self, obj, **kwargs):
        if isinstance(obj, (mongoengine.Document, mongoengine.EmbeddedDocument)):
            out = dict()
            for k, v in obj._data.iteritems():
                if isinstance(v, datetime.datetime):
                    out[k] = v.strftime(DT_FORMAT)
                elif isinstance(v, datetime.date):
                    out[k] = v.strftime('%Y-%m-%d')
                elif isinstance(v, DBRef):
                    out[k] = {'collection': v.collection,
                            'id': str(v.id),
                            'database': v.database}
                elif isinstance(v, ObjectId):
                    out['id'] = str(v)
                else:
                    out[k] = v
            return out
        elif isinstance(obj, mongoengine.queryset.QuerySet):
            return list(obj)
        elif isinstance(obj, types.ModuleType):
            return None
        elif isinstance(obj, groupby):
            return [ (g,list(l)) for g,l in obj ]
        elif isinstance(obj, (list,dict)):
            return obj
        return super(MongoEngineEncoder, self).default(obj, **kwargs)

def mongo_jsonify(*args, **kwargs):
    if __debug__:
        _assert_have_json()
    return current_app.response_class(json.dumps(dict(*args, **kwargs),
        indent=None if request.is_xhr else 2, cls=MongoEngineEncoder), mimetype='application/json')
