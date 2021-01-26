# Running MongoDb in a Docker Container for Dev and Test Environments

This set up will run a Mongo Database from a container for development. We can also run a seeded database for testing.

## Scripts and Mongo Directory

Make this directory at the root of the project:
```
/Scripts
 - /Mongo
 - - /mongodb
 - - /mongodbinit
 - - - mongoInit.js
 - - - .dbshell
 - - /mongodb_seed
 - - - Dockerfile
 - - - MOCK_DATA.json
 - - - mongo_seed.sh
```

These are the files:

`mongoInit.js` -- Creates the application database and application user
```javascript
// use shell command to save env variable to a temporary file, then return the contents.
// source: https://stackoverflow.com/questions/39444467/how-to-pass-environment-variable-to-mongo-script/60192758#60192758
function getEnvVariable(envVar, defaultValue) {
  var command = run("sh", "-c", `printenv --null ${ envVar } >/tmp/${ envVar }.txt`);
  // note: 'printenv --null' prevents adding line break to value
  if (command != 0) return defaultValue;
  return cat(`/tmp/${ envVar }.txt`)
}

// create application user
var dbName = getEnvVariable('DB_NAME', 'MyDatabase');
var dbCollectionName = getEnvVariable('DB_COLLECTION_NAME', 'MyCollection');
db = db.getSiblingDB(dbName);
db.createUser({
  'user': getEnvVariable('APP_USER', 'MyAppUser'),
  'pwd': getEnvVariable('APP_PWD', 'MyAppUser()'),
  'roles': [
    {
      'role': 'dbOwner',
      'db': getEnvVariable('DB_NAME', 'MyDatabase')
    }
  ]
});
db.createCollection(dbCollectionName);
```
`.dbshell` -- is empty. This just creates a mongodb user

`Dockerfile` -- a docker file for a seeded test database. I'll paste the contents later

`MOCK_DATA.json`-- data to seed, from Mockaroo or wherever else

`mongo_seed.sh` -- a script to seed a test database. This file is also available in the Dev container in case you need to generate records
```bash
if [ -f "/MOCK_DATA.json" ]; then
  FILE="/MOCK_DATA.json"
  echo $FILE
elif [ -f "./MOCK_DATA.json" ]; then
  FILE="./MOCK_DATA.json"
  echo $FILE
else
  echo "Mock data file not found. Make sure container has a MOCK_DATA.json file for this script to work"
  exit 1
fi

mongoimport --host mongodb_test \
  --authenticationDatabase $DB_NAME \
  --username $APP_USER --password $APP_PWD \
  --db $DB_NAME \
  --collection $DB_COLLECTION_NAME \
  --file $FILE --jsonArray
```

## Environment Varables

Add a `.env` at the root of the project with values for the following
```
MONGO_INITDB_ROOT_USERNAME=mongo_root
MONGO_INITDB_ROOT_PASSWORD=mongo_root()
APP_USER=app_user
APP_PWD=app_user()
DB_NAME=MyDatabase
DB_COLLECTION_NAME=MyCollection
```

## Docker Compose Dev

`docker-compose-dev.yaml` -- Runs a MongoDb for localdevelopment, exposed at port :28017. 
```yaml
version: "3"
services:
  mongodb:
    container_name: imaging_manager_mongo
    image: mongo:latest
    volumes:
      - ./Scripts/Mongo:/docker-entrypoint-initdb.d
      - ./Scripts/Mongo/mongodb:/home/mongodb
      - img_data:/data/db
    ports:
      - "28017:27017"
    environment:
      - MONGO_INITDB_ROOT_USERNAME=$MONGO_INITDB_ROOT_USERNAME
      - MONGO_INITDB_ROOT_PASSWORD=$MONGO_INITDB_ROOT_PASSWORD
      - APP_USER=$APP_USER
      - APP_PWD=$APP_PWD
      - DB_NAME=$DB_NAME
      - DB_COLLECTION_NAME=$DB_COLLECTION_NAME
volumes:
  img_data:
```

The database can be run with:
```bash
docker-compose -f ./docker-compose-dev.yaml up
```
The database can be accessed with:
```bash
docker exec -it imaging_manager_mongo bash
```
In the container, the database can optionally be seeded with:
```bash
$ cd docker-entrypoint-initdb.d
$ bash mongo_seed.sh
```
In the application or on the host machine, the connection string would be:
```
"mongodb://app_user:app_user()@localhost:28017/ImagingManager"
```

## Docker Compose Test

In `./Scripts/Mongo/mongodb_seed`, add a `Dockerfile`:
```Dockerfile
FROM mongo:latest
COPY ./mongo_seed.sh /mongo_seed.sh
COPY ./MOCK_DATA.json /MOCK_DATA.json
ENTRYPOINT ["/bin/bash", "/mongo_seed.sh"]
```
In the root of the project, add `docker-compose-test.yaml`:
```yaml
version: "3"
services:
  mongodb_test:
    container_name: imaging_manager_mongo
    image: mongo:latest
    volumes:
      - ./Scripts/Mongo:/docker-entrypoint-initdb.d
      - ./Scripts/Mongo/mongodb:/home/mongodb
      - img_data_test:/data/db
    ports:
      - "29017:27017"
    environment:
      - MONGO_INITDB_ROOT_USERNAME=$MONGO_INITDB_ROOT_USERNAME
      - MONGO_INITDB_ROOT_PASSWORD=$MONGO_INITDB_ROOT_PASSWORD
      - APP_USER=$APP_USER
      - APP_PWD=$APP_PWD
      - DB_NAME=$DB_NAME
  imagingdb_seed:
    build: './Scripts/Mongo/mongodb_seed'
    environment:
      - APP_USER=$APP_USER
      - APP_PWD=$APP_PWD
      - DB_NAME=$DB_NAME
      - DB_COLLECTION_NAME=$DB_COLLECTION_NAME
    links:
      - mongodb_test
volumes:
  img_data_test:

```
Build the seed image:
```bash
docker-compose -f ./docker-compose-test.yaml build
```
Run the image:
```bash
docker-compose -f ./docker-compose-test.yaml up
```
This database should be identical to the Dev DB, but available on port `29017`

To clean the test database:
```bash
docker volume rm imagingmanager_img_data_test
```

I added these npm scripts for convenience:
```json
"scripts": {
    "...": "...",
    "mongo": "docker-compose -f ./docker-compose-dev.yaml up",
    "mongo:clean": "docker volume rm imagingmanager_img_data",
    "mongo:up": "docker-compose -f ./docker-compose-dev.yaml up",
    "mongo:down": "docker-compose -f ./docker-compose-dev.yaml down",
    "mongo:test:build": "docker-compose -f ./docker-compose-test.yaml build",
    "mongo:test:up": "docker-compose -f ./docker-compose-test.yaml up",
    "mongo:test:clean": "docker volume rm imagingmanager_img_data_test"
  },
```