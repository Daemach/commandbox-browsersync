# BrowserSync for CommandBox

Install browsersync using commandbox:

# Installation:
```json
install commandbox-browsersync
```

This tool requires [nodejs](https://nodejs.org), (unfortunately).   Once you install that, cd to your site root and:

```json
browsersync
```

If the dependencies don't exist we'll attempt to install them for you.

## Caviat Emptor
The npm installs will likely fail if your site is in a dropbox folder or has anything else running that may lock files.  If npm fails, shut down any program that is using the site folder while the installs are going on.  This part of the process only happens once.

The tool will launch your server if it's not already running and create a proxy with nodejs browsersync.  You'll end up with 2 tabs open - one for your original site and another on port 3000.  Any changes to files in your layouts, views, handlers or models folders will cause the browser on port 3000 to reload.

There is a lot I can do to make this better, but it works for me at the moment.  If there is any interest, I'll streamline it and add more functionality.