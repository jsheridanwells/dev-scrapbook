# Initializing Angular Library Projects

[From....](https://blog.angularindepth.com/creating-a-library-in-angular-6-87799552e7e5)  [and....](https://blog.angularindepth.com/angular-workspace-no-application-for-you-4b451afcc2ba)

#### Since Angular 7 cli...

Create the workspace with no application:
```bash
$ ng new my-lib-project createApplication=false
```

This creates __angular.json__, __package.json__, __tsconfig.json__ and other base files, but no actual code.

Cd into the folder and generate the library:
```bash
$ cd my-lib-project
$ ng g library my-library --prefix=jeremy
```

This creates a separate my-library directory with a module, component, and service boilerplate as well as tests.

Create a consuming or test harness application:
```bash
$ ng g application my-library-test-harness
```

