# -*- coding: utf-8 -*-
"""
    Dash Tests
    ~~~~~~~~~~~~

    Tests the Dash application.
"""
import os
import dash
import unittest
import tempfile


class DashTestCase(unittest.TestCase):

    def setUp(self):
        """Before each test, set up a blank database"""
        self.db_fd, dash.app.config['DATABASE'] = tempfile.mkstemp()
        self.app = dash.app.test_client()
        dash.init_db()

    def tearDown(self):
        """Get rid of the database again after each test."""
        os.close(self.db_fd)
        os.unlink(dash.app.config['DATABASE'])

    def login(self, username, password):
        return self.app.post('/login', data=dict(
            username=username,
            password=password
        ), follow_redirects=True)

    def logout(self):
        return self.app.get('/logout', follow_redirects=True)

    # testing functions

    def test_empty_db(self):
        """Start with a blank database."""
        rv = self.app.get('/')
        assert 'No entries here so far' in rv.data

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

    def test_messages(self):
        """Test that messages work"""
        self.login(dash.app.config['USERNAME'],
                   dash.app.config['PASSWORD'])
        rv = self.app.post('/add', data=dict(
            title='<Hello>',
            text='<strong>HTML</strong> allowed here'
        ), follow_redirects=True)
        assert 'No entries here so far' not in rv.data
        assert '&lt;Hello&gt' in rv.data
        assert '<strong>HTML</strong> allowed here' in rv.data


if __name__ == '__main__':
    unittest.main()
