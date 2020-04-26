const gulp = require('gulp');
const axios = require("axios");
const bs = require('browser-sync').create(); 
const { reload } = bs;

const url = "http://|serverHost|:|serverPort|/healthcheck?fwreinit=1";

|paths|

gulp.task('watch', () => {
    gulp.watch(paths.refresh, (done) => {
        reload();
        done();
    });
    gulp.watch(paths.reinit, (done) => {
        console.log("Reinitializing coldbox framework");
        axios.get(url)
        .then(response => {
            console.log(response.data.trim());
            reload();
        })
        .catch(error => {
            console.log("Error:  Please ensure you have a /healthcheck route set up in /config/router.cfc!");
            console.log("Error:  Once you've done that, please shut down commandbox then try browsersync again.");
            console.log("Error:  More info at https://github.com/Daemach/commandbox-browsersync/blob/master/README.md");
        });

        done();
    });
});

gulp.task('proxy', () => {
    bs.init({
        proxy: "localhost:|serverPort|",
        port: |proxyPort|,
        open: true,
        notify: false
    });
});

gulp.task('default', gulp.parallel('watch', 'proxy'));
