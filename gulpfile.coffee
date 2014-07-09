gulp       = require 'gulp'
gutil      = require 'gulp-util'
coffee     = require 'gulp-coffee'
rename     = require 'gulp-rename'
uglify     = require 'gulp-uglify'
stylus     = require 'gulp-stylus'
clean      = require 'gulp-clean'
concat     = require 'gulp-concat'
sourcemaps = require 'gulp-sourcemaps'
argv       = require('minimist') process.argv

STYLES_PATH = require './src/styl/includes.coffee'
COFFEE_PATH = require './src/coffee/includes.coffee'
VENDOR_PATH = ['./src/vendor/**/*']
IMAGES_PATH = ['./src/img/**/*']
INDEX_PATH  = ['./src/index.html']

BUILD_PATH  = argv.outputDir ? 'dist'

SERVER_PORT = argv.port ? 9800

log = (color, message) -> gutil.log gutil.colors[color] message

watchLogger = (color, watcher) ->
  watcher.on 'change', (event) ->
    log color, "file #{event.path} was #{event.type}"

gulp.task 'serve', ['build'], ->
  express = require 'express'
  app     = express()

  app.use express.static "#{__dirname}/#{BUILD_PATH}"

  app.get '*', (req, res) ->
    { url }    = req
    redirectTo = "/index.html"

    res.header 'Location', redirectTo
    res.send 301

  app.listen SERVER_PORT

  log 'green', "Server for #{BUILD_PATH} is ready at localhost:#{SERVER_PORT}"
  return

gulp.task 'styles', ->

  gulp.src STYLES_PATH
    .pipe stylus()
    .pipe rename "style.css"
    .pipe gulp.dest "#{BUILD_PATH}/css"

gulp.task 'watch-styles', -> watchLogger 'cyan', gulp.watch STYLES_PATH, ['styles']

gulp.task 'coffee', ->

  gulp.src COFFEE_PATH
    .pipe sourcemaps.init()
    .pipe coffee bare: yes
    .pipe concat 'app.js'
    .pipe uglify()
    .pipe sourcemaps.write('./')
    .pipe gulp.dest "#{BUILD_PATH}/js"

gulp.task 'watch-coffee', -> watchLogger 'cyan', gulp.watch COFFEE_PATH, ['coffee']

gulp.task 'vendor', ->

  gulp.src VENDOR_PATH

    .pipe gulp.dest "#{BUILD_PATH}/vendor"

gulp.task 'watch-vendor', -> watchLogger 'yellow', gulp.watch VENDOR_PATH, ['vendor']

gulp.task 'images', ->

  gulp.src IMAGES_PATH
    .pipe gulp.dest "#{BUILD_PATH}/img"

gulp.task 'watch-images', -> watchLogger 'yellow', gulp.watch IMAGES_PATH, ['images']

gulp.task 'index', ->

  gulp.src INDEX_PATH
    .pipe gulp.dest "#{BUILD_PATH}"

gulp.task 'watch-index', -> watchLogger 'yellow', gulp.watch INDEX_PATH, ['index']

gulp.task 'clean', ->
  gulp.src [BUILD_PATH], read: no
    .pipe clean force: yes

gulp.task 'build', ['styles', 'coffee', 'vendor', 'images', 'index']

watchersArray = [
  'watch-styles'
  'watch-coffee'
  'watch-vendor'
  'watch-images'
  'watch-index'
]

gulp.task 'watchers', watchersArray

gulp.task 'watch', ['build'].concat watchersArray

gulp.task 'default', ['watch', 'serve']

