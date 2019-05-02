# Adding Bootstrap 4 to an Angular 5 app:

1. Add Bootstrap dependency:
```
$ npm install --save bootstrap
```

2. Add Bootstrap CSS to `styles.css`:
```
@import "~bootstrap/dist/css/bootstrap.css"
```

3. Any starter templates go in `app.component.html`

4. Add Bootstrap DOM code for angular:
```
npm install --save @ng-bootstrap/ng-bootstrap
```

5. Import code in `app.module.ts`:
```
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
```
