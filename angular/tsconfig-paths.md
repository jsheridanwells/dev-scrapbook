# Adding tsconfig paths

Angular now generates the root `tsconfig.json` and a `tsconfig.app.json` which extends the root config.

The `"baseUrl"` in the root config is "./"...
```json
{
  "compileOnSave": false,
  "compilerOptions": {
    "baseUrl": "./",
    
    // ... //
```

In `tsconfig.app.json`, we can set the paths:
```json
{
  "extends": "../tsconfig.json",
  "compilerOptions": {
    "outDir": "../out-tsc/app",
    "types": [],
    "paths": {
      "@app/*": ["client/src/app/core/*"],
      "@env/*": ["client/src/environments/*"],
      "@shared/*": ["client/src/app/shared/*"]
    }
  },
```
_(note: the `client` dir separates it from the `server` dir in this project)_

Now these paths can be referenced in the `.ts` files:
```typescrypt
import { GoogleService } from '@app/services/google.service';
import { environment } from '@env/environment';
```
