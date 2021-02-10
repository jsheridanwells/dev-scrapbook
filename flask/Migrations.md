# Migrations

Flask-Migrate process:

> init

> migrate

> upgrade

> downgrade

(migrate creates the migration files, but upgrade actually applies them to the db)

Model must be registered in `application.py`:
```python
    db.init_app(app)
    migrate = Migrate(app, db)
```

Model is 'seen' in the view file that contains it, for example, in `views.py`:
```python
from counter.models import Counter
```

Initialize: `$ flask db init`

### Checking CRUD ops in the Flask Console:

```bash
$ flask shell
>>> from counter.models import Counter
>>> from application import db
>>> Counter.query.all()
[]
>>> counter = Counter(count=1)
>>> counter.id
>>> db.session.add(counter)
>>> ^[[A^[[A^[[A^[[B^C
KeyboardInterrupt
>>> Counter.query.all()
[<Count 1>]
>>> db.session.commit()
>>> counter.id
1
>>> counter_1 = Counter.query.get(1)
>>> counter_1
<Count 1>
>>> counter_1.count
1
>>> counter_lit = Counter.query.all()
>>> counter_lit
[<Count 1>]
>>> counter = Counter.query.get(1)
>>> counter.count
1
>>> counter.count = 2
>>> db.session.commit()
>>> counter = Counter.query.get(1)
>>> counter
<Count 2>
>>> db.session.delete(counter)
>>> db.session.commit()
>>> Counter.query.all()
[]
>>>
```


