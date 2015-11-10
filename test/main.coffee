html = require('../')
fs = require 'fs'
path = require 'path'
gulp = require('gulp')
assert = require('stream-assert')
funsert = require 'funsert'
cheerio = require 'cheerio'
require('mocha')

fixtures = (file) -> path.join(__dirname, 'fixtures', file)

describe 'gulp-html-transform', ->

  describe 'parse()', ->
    it 'should attach document property to file object', (done) ->
      gulp.src('test/fixtures/example.html')
        .pipe html.parse()
        .pipe assert.length(1)
        .pipe assert.first funsert.hasProperty('document')
        .pipe assert.end(done)

  describe 'transform()', ->
    it 'receives root selector', (done) ->
      assertTitleText = funsert.equal('Transformation Test')
      gulp.src('test/fixtures/example.html')
        .pipe html.parse()
        .pipe assert.length(1)
        .pipe html.transform ($) -> assertTitleText($('title').text())
        .pipe assert.end(done)

  describe 'write()', ->
    it 'updates file contents', (done) ->
      assertFileContents = funsert.matches(/nailed it/)
      gulp.src('test/fixtures/example.html')
        .pipe html.parse()
        .pipe html.transform ($) -> $('body').append('nailed it')
        .pipe html.write()
        .pipe assert.first (d) -> assertFileContents(d.contents.toString())
        .pipe assert.end(done)
