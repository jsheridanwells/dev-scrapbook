# Angular Material Theming

I. [From....](https://medium.com/@tomastrajan/the-complete-guide-to-angular-material-themes-4d165a9d24d1)

### Basically, select three colors for primary, accent and warn:
```scss
// define 3 theme color
// mat-palette accepts $palette-name, main, lighter and darker variants
$my-theme-primary: mat-palette($mat-indigo, 700, 300, 900);
$my-theme-accent: mat-palette($mat-light-blue);
$my-theme-warn: mat-palette($mat-deep-orange, A200);

// create theme (use mat-dark-theme for themes with dark backgrounds)
$my-theme: mat-light-theme(
    $my-theme-primary,
    $my-theme-accent,
    $my-theme-warn
);
```
Numbers mean default, light, and dark variants.

Load your theme into the entry .scss file (styles.scss or whatever)"
```scss
@import '~@angular/material/theming';

// always include only once per project
@include mat-core();

// import our custom theme
@import 'my-theme.scss';

// specify theme class eg: <body class="my-theme"> ... </body>
.my-theme {
  
  // use our theme with angular-material-theme mixin
  @include angular-material-theme($my-theme);
}
```

[This site](https://www.materialpalette.com/) is helpful for selecting palettes.

II. [Alternate Theming File Example](https://material.angular.io/guide/theming)
```scss
@import '~@angular/material/theming';
// Plus imports for other components in your app.

// Include the common styles for Angular Material. We include this here so that you only
// have to load a single css file for Angular Material in your app.
// Be sure that you only ever include this mixin once!
@include mat-core();

// Define the palettes for your theme using the Material Design palettes available in palette.scss
// (imported above). For each palette, you can optionally specify a default, lighter, and darker
// hue. Available color palettes: https://material.io/design/color/
$candy-app-primary: mat-palette($mat-indigo);
$candy-app-accent:  mat-palette($mat-pink, A200, A100, A400);

// The warn palette is optional (defaults to red).
$candy-app-warn:    mat-palette($mat-red);

// Create the theme object (a Sass map containing all of the palettes).
$candy-app-theme: mat-light-theme($candy-app-primary, $candy-app-accent, $candy-app-warn);

// Include theme styles for core and each component used in your app.
// Alternatively, you can import and @include the theme mixins for each component
// that you are using.
@include angular-material-theme($candy-app-theme);
```


III. [Typography](https://material.angular.io/guide/typography)
```scss
@import '~@angular/material/theming';

// Define a custom typography config that overrides the font-family as well as the
// `headlines` and `body-1` levels.
$custom-typography: mat-typography-config(
  $font-family: 'Roboto, monospace',
  $headline: mat-typography-level(32px, 48px, 700),
  $body-1: mat-typography-level(16px, 24px, 500)
);
```
