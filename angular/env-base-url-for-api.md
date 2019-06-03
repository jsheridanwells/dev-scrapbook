# setting env constants

[(My favorite answer....)](https://stackoverflow.com/a/46532683/9316547)

1. in `environment.ts`, put in whatever settings you need:
```typescript
export const environment = {
  production: false,
  apiBase: "https://localhost:5001/api/"
};
```

2. create a catch-all for constants that come from settings (mine is `config/appSettings.ts`:
```
import { environment } from '../../environments/environment';

export const API_BASE = environment.apiBase;
```

3. Use it wherever:
```typescript
import { API_BASE } from '../config/appSettings';
```

