# Themable Libraries in Angular

[See this...](https://www.usefuldev.com/post/Angular:%20create%20a%20library%20that%20supports%20Angular%20Material%20theming) and [this example repo...](https://github.com/JayChase/themeable-library-sample)

__Setup__:
```bash
ng new themable-library --createApplication=false

cd themable-library

ng generate library themable-library

ng generate application themable-library-application

ng add @angular/material --interactive-false
```

__Sharing Styles__

Now you have a library and a test application, living side-by-side in `projects/`. Material has been installed.

## Adding shared styles between projects

Add shared-styles directory
```bash
$ mkdir projects/shared-styles
```

Make `angular.json` know about it:
```json
"projects: : {
  "themable-library-application": {
    // ...
    "architect": {
      "build": {
        "builder": "@angular-devkit/build-angular:browser",
          "options": {
            // etc....
          "stylePreprocessorOptions": {
            "includePaths": ["projects/shared-styles"]
            // etc....
        }
      }
    }
  }
}
```

Make `ng-builder` know about it:
```json
{
  "$schema": "../../node_modules/ng-packagr/ng-package.schema.json",
  "dest": "../../dist/bcd-shell",
  "deleteDestPath": false,
  "lib": {
    "entryFile": "src/public-api.ts",
    "styleIncludePaths": ["../shared-styles"]
  }
}
```

In library, create a mixin that will import component themes and pass the material theme:
```scss
@import 'test/test.component.theme.scss';

@mixin test-lib-theme($test-app-theme) {
  @include test-component-theme($test-app-theme);
}
```

__scss-bundle__

Install it:
```bash
$ npm install --save-dev scss-bundle
```

An `scss-bundle.config.json` needs to be added in the `src` folder of each project:
```json
{
  "entry": "./projects/test-lib/src/lib/theme/test-lib.theme.scss",
  "dest": "./dist/themable-library/my.theme.scss",
  "includePaths": ["projects/shared-styles"]
}
```
The entry is the theme for the library, the destination is the library's place in the `dist` directory.

Add scss-bundle to build tasks in root package.json
```json
  "scripts": {
    "ng": "ng",
    "start": "ng serve",
    "build": "npm run test-lib:build && npm run web-app:build",
    "test-lib:build": "ng build test-lib && scss-bundle -c projects/test-lib/src/scss-bundle.config.json",
    "web-app:build": "ng build web-app",
    "test": "ng test",
    "lint": "ng lint",
    "e2e": "ng e2e"
  }
```

In `angular.json`, add `dist` folder to `stylePreprocessorOptions`:
```json
"projects": {
    "themable-library-application": {
     // etc...
      },
      "architect": {
        "build": {
          "builder": "@angular-devkit/build-angular:browser",
          "options": {
            // etc...
            "stylePreprocessorOptions": {
              "includePaths": ["projects/shared-styles","dist"]
            }
            // etc...
```

Lastly, `npm run build` and you should be good to go.

