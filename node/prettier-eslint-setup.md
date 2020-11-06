# Setting up Prettier and ESLint

1. ESLint:
```bash
$ npm install -D eslint
```

2. Init:
```bash
$ npx eslint --init
```
From there, you can select options.

3. Prettier:
```bash
$ npm install -D prettier eslint-config-prettier eslint-plugin-prettier
```

4. sample `.eslintrc.json`
```json
{
    "env": {
        "browser": true,
        "commonjs": true,
        "es2020": true
    },
    "extends": [
        "airbnb-base",
        "prettier"
    ],
    "plugins": ["prettier"],
    "parserOptions": {
        "ecmaVersion": 11
    },
    "rules": {
    }
}

```

5. `.prettierrc`
```
{
  "trailingComma": "es5",
  "printWidth": 100,
  "singleQuote": true
}

```