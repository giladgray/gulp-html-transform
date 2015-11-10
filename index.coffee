cheerio = require 'cheerio'
map = require 'through2-map'

###
Stream-based HTML transformation library, designed for use with Gulp
(object-mode Transform streams).

# Usage

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
###

# parse an HTML file into `file.document`
parse = -> map.obj (file) ->
  file.document = cheerio.load(file.contents.toString())
  return file

# transform an HTML document.
# function receives root selector of document and file path.
transform = (fn) -> map.obj (file) ->
  fn.call(@, file.document, file.path)
  return file

# write an HTML document back to `file.contents`
write = -> map.obj (file) ->
  # TODO: prettyprint?
  file.contents = new Buffer(file.document.html())
  delete file.document
  return file

###
# Transformers

A number of built-in transformers to simplify the process.

[Cheerio](https://github.com/cheeriojs/cheerio) is used internally to
parse the file, and can be used by you to transform it! Have access to
the entire document, or use helpers for common operations.
###

# restrict a document body to just the given content selectors
transform.contents = (selectors...) ->
  transform ($) ->
    # confine to content selector
    $('body').html($(selectors.join(', d')))

# perform a function for each match of the given selector
transform.each = (selector, fn) ->
  transform ($, filename) ->
    ctx = @
    $(selector).each -> fn.call(ctx, $(@), filename)

# string replace the given attr on each match of selector
transform.replace = (selector, attr, find, replace) ->
  transform.each selector, ($el) ->
    $el.attr(attr, $el.attr(attr)?.replace(find, replace))

# invoke a method on each match of the given selector.
# see Cheerio API for methods and arguments.
transform.invoke = (selector, methodName, args...) ->
  tranform.each selector, ($el) ->
    $el[methodName](args...)


module.exports = {parse, transform, write}
