# From Zero to Flask Notes

### Virtual Envs

-- libs and source in their own environment rather than interfering with machine

to make an env:
```bash
$ python -m venv venv
```

to activate:
```bash
$ source venv/bin/activate
```

to deactivate:
```bash
$ deactivate
```

### Installing Flask

To upgrade PIP:
```bash
$ pip install --upgrade pip
```

w/ venv activated, install w/ version number:
```bash
$ pip install Flask==1.0.2
```

### Simple Hello World
```python
from flask import Flask

# instance of flask class
# __name__ tells flask which module it is running from
app = Flask(__name__)

# this is a decorator
@app.route('/')
def hola():
    return 'Hola, huevon!'
```

### Running the application

(w/ virtualenv activated)

Set an environment variable to indicate what application to run
```bash
$ export FLASK_APP=hola
```

Then: `$ flask run ` It will run at `http://localhost:5000/`

### Debugging

Set up the environment
```bash
$ export FLASK_DEBUG=1
```

### Routing

In Flask, it's done through the route decorator

### Templates (MVC Views)

Flask will look for a `templates` directory.

If there's: `./templates/index.html'

It can be rendered as
```python
from flask import Flask, render_template

@app.route('/')
def index():
    return render_template('index.html')
```

Template variables:
```html
<h1>
    Hello {{ t_name }}
</h1>
```
```python
@app.route('/hello/<name>')
def hello(name):
    return render_template('hello.html', t_name=name)
```

Dynamic urls:
```html
    <a href="{{ url_for('hello', name='artie') }}">Say hi to Artie</a>
```
```python
@app.route('/hello/<name>')
def hello(name):
    return render_template('hello.html', t_name=name)
```

### Block Templates

In `base.html`:
```html
<html>
<head>
    <title>
        {% block title %} Default Title {% endblock %}
    </title>
    <link rel="stylesheet" href="{{ url_for('static', filename='base.css') }}">
</head>
<body>
    {% block content %} {% endblock %}
</body>
</html>
```
In extending template:
```html
{% extends "base.html" %}
{% block title %}
    HELLO!
{% endblock %}
{% block content %}
<h1>
    Hello {{ t_name }}
</h1>
{% endblock %}
```

### Static folder

`/static` is for anything that won't change (css, images)

Link to it dynamically: `<link rel="stylesheet" href="{{ url_for('static', filename='base.css') }}">`

### Forms

Route parameters:
```python
@app.route('/form', methods=['GET'])
def form():
    first_name = request.args['first_name']
    last_name = request.args['last_name']
    return f'FirstName: { first_name }, Last Name: { last_name }'

```
Returns values from url params: `http://localhost:5000/form?first_name=hopper&last_name=john`

Changing first_name and last_name vars like this will make it
so that either parameter is optional:
```python
    first_name = request.args.get('first_name')
    last_name = request.args.get('last_name')
```

Using an HTML form:
```html
<form action="{{ url_for('form') }}">
    <input type="text" name="first_name" id="first-name">
    <input type="text" name="last_name" id="last-name">
    <input type="submit" name="name_form" value="send me yer name">
</form>
```

Change flask route to:
```python
@app.route('/form', methods=['GET'])
def form():
    if request.args.get('name_form'):
        first_name = request.args.get('first_name')
        last_name = request.args.get('last_name')
        return f'FirstName: { first_name }, Last Name: { last_name }'
    return render_template('form.html')
```
`request.args.get('name_form'):` matches `name="name_form"` in input:submit.

if 'name_form' is sent with the request, accept that first and last name values
but if not, just render the form.html template.

Change it to a POST:

1. Add `method="POST"` to the `<form>` tag.
    
2. Change flask method to:
```python
@app.route('/form', methods=['GET', 'POST'])
def form():
    if request.method == 'POST':
        first_name = request.form.get('first_name')
        last_name = request.form.get('last_name')
        return f'FirstName: { first_name }, Last Name: { last_name }'
    return render_template('form.html')
```
Adds 'POST' to accepted methods, gets data from the form, not the url.
(another way is `first_name = request.values.get('first_name')`) which works with GET and POST

### Cookies and Sessions

Adding the following to the end of the `form` method:
```python
        response = make_response(redirect(url_for('registered')))
        response.set_cookie('first_name', first_name)
        return response
```
makes the `first_name` value available in the next method:
```python
@app.route('/thank_you')
def registered():
    first_name = request.cookies.get('first_name')
    return f'Thank You, {first_name}'
```

Sessions encrypt cookie data

Add a secret to your app:
```python
app.secret_key = 'shhhh_this_is_a_secret'
```

Load the session:
```python
        session['first_name'] = first_name
        return redirect(url_for('registered'))
```
Now it's available on other pages:
```python
first_name = session.get('first_name')
```

### Config

Configuration can be saved in `requirements.txt` at the app root level.

In the requirements file, you can specifify libraries and versions:
```
Flask==1.0.2
```
Then for a fresh install:
```bash
$ pip install -r requirements.txt
```
__WARNING__: Make sure `venv` is activated or else you'll install those libraries across all code repos.

__Python Dot Env__ makes it easier to store more environment data. Normally this is kept in the gitignore 'cuz it's got connection strings and all that.

Add `python-dotenv==0.8.2` (or whatever version you want) to the `requirements.txt`

then, pip install

Create a file called `settings.py` that can store the values that flask 
will push from the environment file to the os settings
```python
import os
SECRET_KEY = os.getenv('SECRET_KEY')
```

Add the settings to the config where the app is instantiated:
```python
app = Flask(__name__)

app.config.from_pyfile('settings.py')
```

Create a `.flaskenv` file. This has got any environment variables. 
Put this in the .gitignore:
```
FLASK_APP='hello.py'
FLASK_ENV=development
SECRET_KEY='shhhhhh_dont_tell_the_Secret'
```
Now `SECRET_KEY` will be available to the app.

