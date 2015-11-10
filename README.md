# gulp-html-transform

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

#### `html.write()`

Stringify `file.document` back to `file.contents`.

#### `html.transform( fn )`

Run a generic transformation on `file.document`. Function receives two arguments:

- `$` the root node of the HTML document. Use Cheerio's API to update the document inline.
- `filename` the path to the current file

## Transform Helpers

#### `html.transform.contents( selectors... )`

Restrict a document body to just the given selectors. All elements that do not match the selectors will be removed from the document.

**Example:** Remove everything except `<article>` and `<script>` tags

```js
html.transform.contents('article', 'script')
```

#### `html.transform.each( selector, fn )`

Perform a function for each match of the given selector. Function will be invoked with two arguments:

- `$el` the current element being transformed
- `filename` the path to the current file

**Example:** Insert anchor tag before each `<h1>` tag

```js
html.transform.each('h1', ($h) => $h.before('<a href="..."></a>'))
```

#### `html.transform.replace( selector, attr, find, replace )`

Perform a string replace on the given attribute for each match of the selector. If the attribute does not exist on a selected element then no action will be performed.

**Example:** Make stylesheet paths absolute

```js
html.transform.replace('link', 'href', '../', '')
```

#### `html.transform.invoke( selector, methodName, args... )`

Invoke a method with the given arguments on each match of the given selector.
See the [Cheerio API](https://github.com/cheeriojs/cheerio) for available methods and arguments.
