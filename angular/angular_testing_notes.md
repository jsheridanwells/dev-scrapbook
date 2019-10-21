# Angular Testing Notes

### Setting up more efficient injection

```typescript
describe('MyService', () => {
  
  let service: MyService; // property at class scope
  
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [MyService]
    });
    
    service = TestBed.get(MyService); // now a fesh service is created before every test
  });
  
  describe('#myMethod', () => {
    let myVal = service.myMethod();
    const whatIExpect: number = 0;
    expect(myVal).toEqual(whatIExpect);
  });
  
  
});

```

### Better Console Reporting

1. Install Karma Spec Reporter
```bash
$ npm install karma-spec-reporter --save-dev
```

2. In `karma.conf.js`:
```javascript
module.exports = function(config) {
  config.set({
    // [...]
    plugins: [
      // [...]
      require('karma-spec-reporter')
    ],
    // [...]
    reporters: ['spec', 'kjhtml]
  });
}
```

3. Enjoy the nicer console.




