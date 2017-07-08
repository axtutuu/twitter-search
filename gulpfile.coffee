gulp = require 'gulp'
sass = require 'gulp-sass'
sass_glob = require 'gulp-sass-glob'
pug  = require 'gulp-pug'
browserify = require 'browserify'
babelify = require 'babelify'
source = require 'vinyl-source-stream'

SRC  = './src'
DEST = './public'

gulp.task 'sass', () ->
  gulp.src "#{SRC}/scss/**/[!_]*.scss"
    .pipe sass_glob()
    .pipe sass()
    .pipe gulp.dest("#{DEST}/css")

gulp.task 'pug', () ->
  gulp.src "#{SRC}/pug/**/[!_]*.pug"
    .pipe pug({
      pretty: true,
      basedir: "#{SRC}/pug"
    })
    .pipe gulp.dest(DEST)

gulp.task 'browserify', () ->
    browserify({
      entries: "#{SRC}/js/script.js"
      extensions: ['js']
    })
    .transform(babelify)
    .bundle()
    .pipe source('script.js')
    .pipe gulp.dest("#{DEST}/js")

gulp.task 'build',   gulp.parallel('sass', 'pug', 'browserify')
gulp.task 'default', gulp.series('build')
