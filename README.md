A basic mustache builder for parsing mustache templates.

## Usage

First, add a dev dependency on this package:

```yaml
dev_dependencies:
  mustache_builder: ^0.1.0
```

The next step is to create a mustache file `*.mustache.html` or rename your `*.html` files to a `*.mustache.html` files. 
Those files will be modified and copied to the original `*.html` location after the parsing.

For now you can bind pubspec variables into your html. 

This is useful for attaching the version of your app or some media host, eg:

```html
<img src="{{ pubspec_media_host }}logo.jpeg" />

<script src="my.js?q={{ pubspec_version }}"></script>
```

And in your pubspec:

```yaml
version: 0.0.5+1
media_host: 'http://media.example.com/' 
```


