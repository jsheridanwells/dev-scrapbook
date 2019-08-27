# Using a Base Service Class For API Calls

[From this great article....](https://codeburst.io/angular-best-practices-4bed7ae1d0b7)

You can put simple AJAX logic in a base class, which could include HTTP verbs, interception, adding tokens, etc....
```typescript
// base-api.service.ts
abstract class BaseApiService {
  protected baseUrl: string = 'http://my-api.com.br';
  
  constructor(
    private _http: HttpClient,
    private _token: MyTokenService
  ) {  }
  
  protected get headers(): HttpHeaders {
    const currentToken: string = _token.getToken();
    return new HttpHeaders({ token: currentToken });
  }
  
  protected get(relativeUrl: string): Observable<any> {
    const opts: RequestOptions = new RequestOptions({ headers: this.headers })
    return this._http.get(this.baseUrl + relativeUrl, opts);
  }
  
  protected post(relativeUrl: string, data<any>): Observable<any> {
    const opts: RequestOptions = new RequestOptions({ headers: this.headers })
    return this._http.post(this.baseUrl + relativeUrl, data, opts)
  }  
}
```

... then implement it
```typescript
@Injectable()
export class ArtieService extends BaseApiService {
  private relativeUrl: string '/artie/'
  
  public getAllArties(): Observable<Artie[]> {
    return this.get(relativeUrl)
  }
  
  public getSingleArtie(artieId: number): Observable<Artie> {
    return this.get(relativeUrl + '/' + artieId.toString());
  }
}
```

Now your derived services can focus on just data management and your components are completely separated from your web API. Yay!
