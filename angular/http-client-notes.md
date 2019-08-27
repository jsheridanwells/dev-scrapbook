# Angular HttpClient

[from docs...](https://angular.io/guide/http)

1. Import `HttpClientModule` (preferrably in AppModule)

2. It can be injected into any service:
```typescript
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Injectable()
export class ConfigService {
  constructor(private http: HttpClient) { }
}
```

## GETting

3. Components can then __subscribe__ to the result of an `HttpClient` method (ex. includes error handling):
```typescript
// service...
import { Observable, throwError } from 'rxjs';
import { catchError, retry } from 'rxjs/operators';
// [...]

configUrl = 'assets/config.json';

getConfig() {
  return this.http.get<Config>(this.configUrl) // type param for typed responses
    .pipe(
      retry(3), // tries request three times just in case
      catchError(this.handleError)
    )
}

private handleError(e: HttpErrorResponse) {
  if (e.error instanceof ErrorEvent { // it's a client-side or network error
    console.error('it is all your fault!', e.error.message);
  } else { // it's a server error
    console.error('our bad...', e.status, e.error);
  }
  return throwError('oopses');
}

// component...
showConfig() {
  this.configService.getConfig()
    .subscribe(
      (data: Config) => this.config = { ...data }, // success path
      error => this.error = error; // error path
    )
}
```

Now, whenever another class called `getConfig()` the component will react to the result.

## POSTing

4. Adding headers

```typescript
// in service...
import { HttpHeaders } from '@angular/common/http';

const httpOptions = {
  headers: new HttpHeaders({
    'Content-Type':  'application/json',
    'Authorization': 'my-auth-token'
  })
};
```

5. To update the headers: 
```typescript
httpOptions.headers =
  httpOptions.headers.set('Authorization', 'my-new-auth-token');
```

6. To make the POST:
```typescript
// service...
/** POST: add a new hero to the database */
addHero (hero: Hero): Observable<Hero> {
  return this.http.post<Hero>(this.heroesUrl, hero, httpOptions) // type parameter expects the server to return the posted object
    .pipe(
      catchError(this.handleError('addHero', hero))
    );
}

// init in component by subscribing
this.heroesService
  .addHero(newHero)
  .subscribe(hero => this.heroes.push(hero)); //add result to the object list
```

