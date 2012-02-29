# -*- coding: utf-8 -*-
from flaskext.mongoengine import MongoEngine
import dash
import unittest

class DashTestCase(unittest.TestCase):
    DB_NAME = 'dash_test'

    def setUp(self):
        """Before each test, set up a blank database"""
        dash.app.config['TESTING'] = True
        dash.app.config['MONGODB_DB'] = self.DB_NAME
        self.db = MongoEngine(dash.app)
        self.app = dash.app.test_client()

    def tearDown(self):
        """Get rid of the database again after each test."""
        self.db.connection.drop_database(self.DB_NAME)

    def login(self, username, password):
        return self.app.post('/login',
            data=dict(username=username, password=password),
            follow_redirects=True)

    def logout(self):
        return self.app.get('/logout', follow_redirects=True)

    # testing functions

    def test_login_logout(self):
        """Make sure login and logout works"""
        rv = self.login(dash.app.config['USERNAME'],
            dash.app.config['PASSWORD'])
        assert 'You were logged in' in rv.data
        rv = self.logout()
        assert 'You were logged out' in rv.data
        rv = self.login(dash.app.config['USERNAME'] + 'x',
            dash.app.config['PASSWORD'])
        assert 'Invalid username' in rv.data
        rv = self.login(dash.app.config['USERNAME'],
            dash.app.config['PASSWORD'] + 'x')
        assert 'Invalid password' in rv.data

#    def test_messages(self):
#        """Test that messages work"""
#        self.login(dash.app.config['USERNAME'],
#                   dash.app.config['PASSWORD'])
#        rv = self.app.post('/add', data=dict(
#            title='<Hello>',
#            text='<strong>HTML</strong> allowed here'
#        ), follow_redirects=True)
#        assert 'No entries here so far' not in rv.data
#        assert '&lt;Hello&gt' in rv.data
#        assert '<strong>HTML</strong> allowed here' in rv.data


if __name__ == '__main__':
    unittest.main()
