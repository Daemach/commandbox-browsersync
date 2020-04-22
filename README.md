# BrowserSync for CommandBox

BrowserSync will automatically refresh your browser window whenever you save files, allowing for fast, efficient development. 

# Installation:

Install browsersync using commandbox:

```
install commandbox-browsersync
```

This tool requires [nodejs](https://nodejs.org), (unfortunately).   Once you install that, cd to your site root and:

```
browsersync [proxyPort=3000] [fwreinit=true]

browsersync 4500 false (proxy port will be 4500, no fwreinit)
```

proxyPort (default: 3000) and fwreinit (default: true) are both optional.

If the dependencies don't exist we'll attempt to install them for you.

## Caviat Emptor
* The npm installs will likely fail if your site is in a dropbox folder or has anything else running that may lock files.  If npm fails, shut down any program that is using the site folder while the installs are going on.  This part of the process only happens once.
* If you want us to reinit the framework automatically on core file changes (models, handlers, config, interceptors) you must have a healthcheck route or handler set up.  If this is not set up browsersync will fail (until I figure out a better way to handle that).  This route is set up by default in /config/router.cfc when using coldbox create app.

```
/config/router.cfc
=============

route("/healthcheck",function(event,rc,prc){
    return "Ok!"; 
});
```

The tool can launch your server if it's not already running and will create a proxy at port 3000 (default) with nodejs browsersync.  Any changes to files in your layouts, views, handlers or models folders will cause the browser to reload.