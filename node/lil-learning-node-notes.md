# Learning Node 

_(LinkedIn Learning)_

## Why javascript?
 - shared libraries between front- and back-end, e.g. lodash, tokenization libs
 - custom functions can be shared
 - dynamic and loosely typed, if you're inot that sort of thing
 - works will w/ JSON

## Sync and async
 - Network and filesystem processes are longest processes to resolve
 - Callbacks and sync allow sync and async functions

## NPM
 - node package manager
 - `$ npm install <PACKAGE NAME>`

__nodemon__ is really useful for Node.js development: `$ npm install -g nodemon`, then `$ nodemon <MYFILE>.js`. Reloads process on file update.

## Frameworks
 - Express - most mature web api framework
 - Sail - ORM features
 - Koa - most modern
 - Socket.io - enables web sockets

## Minimal Express starter

_server.js_

```js
const express = require('express')
const app = express()
const bodyParser = require('body-parser') // enables parsing request.body as objects

app.use(express.static(__dirname)) // serves static files
app.use(bodyParser.json()) // parses requests as json
app.use(bodyParser.urlencoded({ extended: false }))

app.get('/my-resource', (req, res) => {
    res.send(new MyResponse())
})

app.post('/my-resource', (res, res) => {
    let data = req.body
    // do something with the data
    res.sendStatus(200, 'Ay O Kay')
})

const server = app.list(3000, () => console.log('Im listening, yo'))
```

## Minimal Socket.io starter

```js
// add to requires
const http = require('http').Server(app) // http is native node lib, "app" is express()
const io = require('socket.io')

io.on('connection', cnx => console.log('socket connected', cnx))

app.post('/my-emitted-resource', (req, res) => {
    let emittedData = req.body // assume body parser is working
    io.emit('emitted-resource', emittedData)
    res.sendStatus(200)
})

const server = http.listen(3000, () => console.log('listening on http now')) // listen on http, not express now
```

In the client
```html
<script src="/socket.io/socket.io.js"></script>
<script>
  const socket = io()

  socket.on('emitted-resource', doSomething)

  function doSomething(withData) {
      console.log(' i just did something...', withData)
  }
</script>
```

## Adding MongoDB via Mongoose

To .env add:
```
MONGO_DB_CONNECTION_STRING= AMMASUPERSECRETCONNECTIONSTRING-ANDHERETHEPASSWORD!!!
```

`$ npm install mongoose dotenv`

```js
const dotenv = require('dotenv')
dotenv.config() // pulls in env vals

const db = process.env('MONGO_DB_CONNECTION_STRING')

const mongoose = require('mongoose')

const MyModel = mongoose.model(myModelName, {
    myFirstKey: Number,
    myOtherKey: String
})

app.get('/mymodels', (req, res) => {
    MyModel.find({}, (err, myModels) => {
        if (err)
          sendStatus(500)

        res.send(myModels)
    })
})

app.post('/mymodels', (req, res) => {
    let newModel = MyModel(res.body)
    myModel.save((err) => {
        if (err)
          sendStatus(500)

        res.sendStatus(200)
    })
})

// put this before const server
mongoose.connect(db, { useMongoClient: true }, err => {
    if (err)
      console.log('mongo connection error: \n', err)
})
```
