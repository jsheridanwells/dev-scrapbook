# Mongo CLI Cheatsheet

[Reference](https://docs.microsoft.com/en-us/aspnet/core/tutorials/first-mongo-app?view=aspnetcore-2.2&tabs=visual-studio-code)

Starting the mongod process:
```bash
$ brew services start mongodb-community@4.0
```


Connecting to mongo shell:
```bash
mongo
```

List available dbs:
```bash
show dbs
```

Connect to a db:
```bash
use my_db_name
```


### Setting up a new DB

 - Create directory for data storage

 - Connect to MongoDb:
 ```bash
mongod --dbpath <directory-you-just-created>
 ```

 - Connect
 ```bash
 mongo
 ```

 - Create the database with USE
 ```bash
 use MyDatabaseDb
 ```

 - Create a collection
 ```bash
 db.CreateCollection('MyCollection')
 ```

 ```bash
 db.MyCollection.insertMany(
     [
         {'Name':'Design Patterns','Price':54.93,'Category':'Computers','Author':'Ralph Johnson'}, 
         {'Name':'Clean Code','Price':43.15,'Category':'Computers','Author':'Robert C. Martin'}
    ]
)
```

- find all:
```bash
db.MyCollection.find({}).pretty()
```

