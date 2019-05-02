# A Flask Factory Setup

In this setup, `application.py` is a factory that initialized routes and the ORM for a Flask app

__requirements.txt__:
```txt
alembic==1.0.7
Click==7.0
Flask==1.0.2
Flask-Migrate==2.4.0
Flask-SQLAlchemy==2.3.2
itsdangerous==1.1.0
Jinja2==2.10
Mako==1.0.7
MarkupSafe==1.1.1
PyMySQL==0.9.3
python-dateutil==2.8.0
python-dotenv==0.10.1
python-editor==1.0.4
six==1.12.0
SQLAlchemy==1.2.18
Werkzeug==0.14.1

```

__.flaskenv__: (remember to .gitignore this)
```txt
FLASK_APP='manage.py'
FLASK_ENV=development
SECRET_KEY='my_secret_key'
DB_HOST=localhost
DB_USERNAME='my_app_user'
DB_PASSWORD='my_password'
DATABASE_NAME='my_database'

```


__settings.py__:
```python
import os

SECRET_KEY = os.getenv('SECRET_KEY')
DB_USERNAME=os.environ['DB_USERNAME']
DB_PASSWORD=os.environ['DB_PASSWORD']
DB_HOST=os.environ['DB_HOST']
DATABASE_NAME=os.environ['DATABASE_NAME']
DB_URI = 'mysql+pymysql://%s:%s@%s:3306/%s' % (DB_USERNAME, DB_PASSWORD, DB_HOST, DATABASE_NAME)
SQL_ALCHEMY_DATABASE_URL = DB_URI
```

__application.py__:
```python
from flask import(
    Flask
)

from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)
    app.config.from_pyfile('settings.py')
    db.init_app(app)
    migrate = Migrate(app, db)
    return app
```
in __manage.py__:
```python
from application import create_app

app = create_app()
```










