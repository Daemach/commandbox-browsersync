# BrowserSync for CommandBox

BrowserSync will automatically refresh your browser window whenever you save files, allowing for fast, efficient development. 

## Installation:

Install browsersync using commandbox:

```
install commandbox-browsersync
```

This tool requires [nodejs](https://nodejs.org), (unfortunately).   Once you install that, cd to your site root and:

```
browsersync [ proxyPort = random ] [ fwreinit = true ]

browsersync 4500 false (proxy port will be 4500, no fwreinit)
```

proxyPort ( default: random ) and fwreinit ( default: true ) are both optional.

If the npm dependencies don't exist we'll attempt to install them for you.

## Caviat Emptor

* The npm installs will likely fail if your site is in a dropbox folder or has anything else running that may lock files.  If npm fails, shut down any program that is using the site folder while the installs are going on.  This part of the process only happens once.
* If you're on Windows, you should also not run the npm installs "as administrator" unless you're logged in as administrator.  The global packages are saved under a user account and will not be available unless you're running everything under that account.
* If you want us to reinit the framework automatically on core file changes (models, handlers, config, interceptors) you must have a "/healthcheck" route or handler set up.  This route is set up by default in /config/router.cfc when using coldbox create app.

```
/config/router.cfc
=============

route("/healthcheck",function(event,rc,prc){
    return "Ok!"; 
});
```

The tool can launch your commandbox server if it's not already running and will create a nodejs browsersync proxy at your commandbox server port + 1, if that port is available, or another random port if not.  Any changes to files in your layouts, views, handlers or models folders will cause the browser to reload.

Browsersync also has a UI that lets you configure its behavior, including the ability to throttle bandwidth so you can simulate slow links (from mobile devices, for example)  You should be able to reach it at http://localhost:3001