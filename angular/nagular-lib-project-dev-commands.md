# CLI Commands for Developing Angular Library + Test Harness Project

[Mostly from here....](http://willtaylor.blog/complete-guide-to-angular-libraries/)

## Init

__Setup:__
```bash
$ ng new my-library --createApplication=false

$ cd my-library

$ ng generate library my-library

$ ng generate application my-library-app
```

__Build it:__
```bash
# (from root)

$ ng build project=my-library
```

## Watching in dev

```bash
$ cd dist/my-library

$ npm link

# (back to root)
$ cd ../..

$ npm link my-library

# watch library changes
$ ng build --project=my-library --watch

# serve the app
$ ng serve --open
```
