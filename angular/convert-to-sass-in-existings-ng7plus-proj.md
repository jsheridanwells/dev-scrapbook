# Converting an Existing Angular 7 project to SASS

### CLI :
```bash
$ ng config schematics.@schematics/angular:component.styleext scss
```

### Or Manually in `angular.json`:

```json
"projects": {
    "MY-PROJECT": {
      "root": "",
      "sourceRoot": "src",
      "projectType": "application",
      "prefix": "app",
      "schematics": {
        "@schematics/angular:component": {
          "styleext": "scss"
        }
      },
```

Change `styles.css` to `styles.scss`

### Bulk convert all .css to .scss:
```bash
$ for file in **/*.css do mv "$file" "${file%.css}.scss" done; 
```
