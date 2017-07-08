gulp = require 'gulp'
sass = require 'gulp-sass'
sass_glob = require 'gulp-sass-glob'
pug  = require 'gulp-pug'
browserify = require 'browserify'
babelify = require 'babelify'
source = require 'vinyl-source-stream'
browser_sync = require 'browser-sync'
watch = require 'gulp-watch'

SRC  = './src'
DEST = './public'
PUBLIC = './public'

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

gulp.task 'browser-sync', () ->
  browser_sync({
    server: {
        baseDir: PUBLIC
    },
    ghostMode: false
  })
  watch ["#{SRC}/scss/**/*.scss"], gulp.series('sass', browser_sync.reload)
  watch ["#{SRC}/js/**/*.js"], gulp.series('browserify', browser_sync.reload)
  watch ["#{SRC}/pug/**/*.pug"], gulp.series('pug', browser_sync.reload)

gulp.task 'build',   gulp.parallel('sass', 'pug', 'browserify')
gulp.task 'default', gulp.series('build', 'browser-sync')
