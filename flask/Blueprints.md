# Blueprints

A typical setup:
```
app_dir/
  manage.py
  application.py
  module_dir/
    views.py
```

In __views.py__:
```python
from flask import Blueprint

this_app_module = Blueprint('this_app_module', __name__)

@this_app_module.route('/')
def init():
    return 'My App, YO!!!'
```

In __application.py__: in the `create_app()` method:
```python
def create_app():
    app = Flask(__name__)
    app.config.from_pyfile('settings.py')
    db.init_app(app)
    migrate = Migrate(app, db)

    from counter.views import this_app_module
    app.register_blueprint(this_app_module)

    return app
```

