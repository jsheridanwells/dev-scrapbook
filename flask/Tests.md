# Tests

The following, in `util/test_db.py` will create and drop a test database uner the root user:
```python
import os
from flask_sqlalchemy import sqlalchemy

class TestDB:
    def __init__(self):
        self.db_name = os.environ['DATABASE_NAME'] + '_test'
        self.db_host = os.environ['DB_HOST']
        self.db_root_password = os.environ['MYSQL_ROOT_PASSWORD']
        if self.db_root_password:
            self.db_username = 'root'
            self.db_password = self.db_root_password
        else:
            self.db_username = os.environ['DB_USERNAME']
            self.db_password = os.environ['DB_PASSWORD']
        self.db_uri = 'mysql+pymysql://%s:%s@%s' % (self.db_username,
            self.db_password, self.db_host)

    def create_db(self):
        # create the database if root user
        if self.db_root_password:
            engine = sqlalchemy.create_engine(self.db_uri)
            conn = engine.connect()
            conn.execute("COMMIT")
            conn.execute("CREATE DATABASE "  + self.db_name)
            conn.close()
        return self.db_uri + '/' + self.db_name

    def drop_db(self):
        # drop the database if root user
        if self.db_root_password:
            engine = sqlalchemy.create_engine(self.db_uri)
            conn = engine.connect()
            conn.execute("COMMIT")
            conn.execute("DROP DATABASE "  + self.db_name)
            conn.close()
```

The following shows the setup and teardown for any testing suite. Note that it's run within pure Python riather than Flask:
```python
import os
import unittest
import pathlib

from dotenv import load_dotenv
env_dir = pathlib.Path(__file__).parents[1]
load_dotenv(os.path.join(env_dir, '.flaskenv'))

from counter.models import Counter
from application import db
from application import create_app as create_app_base
from util.test_db import TestDB

class CounterTest(unittest.TestCase):
    def create_app(self):
        return create_app_base(
            SQL_ALCHEMY_DATABASE_URI=self.db_uri,
            TESTING=True,
            SECRET_KEY='mySecret'
        )
    
    def setup(self):
        self.test_db = TestDB()
        self.db_uri = self.test_db.create_db()
        self.app_factory = self.create_app()
        self.app = self.app_factory.test_client()
        with self.app_factory.app_context():
            db.create_all()
    
    def tearDown(self):
        with self.app_factory.app_context():
            db.drop_all()
        self.test_db.drop_db()
```
```diff
- CAREFUL :: For some reason this drops the real database!!!!
```

Create a test runner in the project root, for example `test_runner.py`:
```python
import sys, pathlib
sys.path.append(pathlib.Path(__file__).parents[0])

import unittest
loader = unittest.TestLoader()
tests = loader.discover('.')
testRunner = unittest.runner.TextTestRunner()

if __name__ == '__main__':
    testRunner.run(tests)
```

To run: `$ python test_runner.py`

(note: I had to `pip install cryptography` to get the mysql root password to work).

Add an assertion in tests.py:
```python
    def test_counter(self):
        rv = self.app.get('/')
        assert '1' in str(rv.data)
        rv = self.app.get('/')
        assert '2' in str(rv.data)
```
