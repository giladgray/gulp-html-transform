# gulp-html-transform

Stream-based HTML transformation library, designed for use with Gulp
(object-mode Transform streams).

## Usage

```coffee
gulp.src 'src/*.html'
  .pipe html.parse()
  # ready to go! now we can transform at will
  .pipe html.transform ($) ->
    $('title').text('TRANSFORMERS!')
  .pipe html.transform ($) ->
    $('link:last-of-type').after('<link href=""></link>')
  # ...pipe html.transform ad inifnitum
  # write HTML back to file when you're done
  .pipe html.write()
  .pipe gulp.dest('public')
```
