const gulp = require('gulp');
const bs = require('browser-sync').create(); // create a browser sync instance.
const { reload } = bs;

var paths = [
    "./layouts/**/*.*",
    "./handlers/**/*.*",
    "./models/**/*.*",
    "./views/**/*.*",
    "./interceptors/**/*.*"
]

gulp.task('watch', () => {
    gulp.watch(paths, (done) => {
        reload();
        done();
    });
});

gulp.task('serve', () => {
    bs.init({
        proxy: "localhost:|serverPort|",
        port: 3000,
        open: true,
        notify: false
    });
});

gulp.task('default', gulp.parallel('watch', 'serve'));
