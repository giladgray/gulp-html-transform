# gulp-html-transform

[![Build Status](https://travis-ci.org/giladgray/gulp-html-transform.svg?branch=master)](https://travis-ci.org/giladgray/gulp-html-transform)

Stream-based HTML transformation library, designed for use with Gulp (object-mode Transform streams).

Uses [Cheerio](https://github.com/cheeriojs/cheerio) internally for HTML manipulation.

## Usage

```js
gulp.src('src/*.html')
  .pipe(html.parse())
  // ready to go! now we can transform at will
  .pipe(html.transform(function($) {
    // change node content
    $('title').text('TRANSFORMERS!')
  }))
  .pipe(html.transform(function($) {
    // add new nodes
    $('link:last-of-type').after('<link href=""></link>')
  }))
  // ...pipe(html.transform) ad infinitum
  // write HTML back to file when you're done
  .pipe(html.write())
  .pipe(gulp.dest('public'))
```

## API

#### `html.parse()`

Parse the `file.contents` to an HTML document and attach it as `file.document`.


`file.document` is an instance of Cheerio containing the parsed HTML file (`cheerio.load(file.contents.toString())`). While it's likely easiest to use the transform methods below, after parsing a file you can do whatever you like with the `document`. Please refer to the [Cheerio API](https://github.com/cheeriojs/cheerio#api) for available methods.

#### `html.write()`

Stringify `file.document` back to `file.contents`.

#### `html.transform(callback)`

Run a generic transformation on `file.document`. `callback` receives two arguments:

- `$` Cheerio instance of the root node of the HTML document
- `filename` string path to the current file


## Transform Helpers

#### `html.transform.contents(...selectors)`

Restrict a document body to just the given selectors (and their children). 
A convenient way to prune huge swaths of the DOM tree at once and focus on relevant content.

**Example:** Keep only the `<article>` and `<script>` tags

```js
html.transform.contents('article', 'script')
```

#### `html.transform.each(selector, callback)`

Invoke a callback for each match of the given selector. `callback` receives two arguments:

- `$el` Cheerio instance of the current element being transformed
- `filename` string path to the current file

**Example:** Insert anchor tag before each `<h1>` tag

```js
html.transform.each('h1', ($h) => $h.before('<a href="..."></a>'))
```

#### `html.transform.replace(selector, attr, find, replace)`

Perform a string replace on the given attribute for each match of the selector. If the attribute does not exist on a selected element then no action will be performed. All parameters are strings.

**Example:** Make stylesheet paths absolute

```js
html.transform.replace('link', 'href', '../', '')
```

#### `html.transform.invoke(selector, methodName, ...args)`

Invoke a Cheerio instance method with the given arguments on each match of the given selector. 
See the [Cheerio API](https://github.com/cheeriojs/cheerio) for available methods and arguments.

Note that `args` will be passed to each invocation of the method; use `html.transform.each` for dynamic arguments.

**Example:** Insert the same anchor tag before each `<h1>` tag

```js
html.transform.invoke('h1', 'before', '<a href="constant"></a>'))
```
