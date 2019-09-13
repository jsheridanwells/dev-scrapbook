# Initializing Angular Library Projects

[From....](https://blog.angularindepth.com/creating-a-library-in-angular-6-87799552e7e5)  [and....](https://blog.angularindepth.com/angular-workspace-no-application-for-you-4b451afcc2ba)
[and this example repo....](https://github.com/t-palmer/example-ng6-lib/tree/master/src/app)

[this on'es good too...](http://willtaylor.blog/complete-guide-to-angular-libraries/)

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

Create a consuming or test harness application (I'm creating it without its own tests):
```bash
$ ng g application my-library-example --skipTests=true
```

Adding components to the library:
```bash
$ ng g c my-lib-component --project=my-library
```
This specifies that the new component is connected to the library not the application.

The new component needs to be added to the exports array in its module in order to be available to other applications:
```typescript
import { MyLibComponent } from './my-lib-component/my-lib-component;

@NgModule({
  imports : [],
  declarations: [
    // ...
    MyLibComponent
  ],
  exports: [
    MyLibComponent
  ]
})
export class MyLibraryModule
```

Also the library has an entry component: `./projects/my-library/src/public-api.ts`. Any code that can be consumed directly in other applications should be listed there:
```typescript
export * from './lib/my-lib-component/my-lib-component';
```

When the component is added to the module exports, the element is consumable in an application; when the component is listed in the public-api.ts, the class itself can be referenced in another application.

Since Angular CLI v7, you can hot reload and incrementally build your library using: `$ ng build my-lib --watch`.
