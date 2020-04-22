component {

    function run(){

        this.basePath = resolvePath( "./");
        
        if (!reMatch("v\d+",command( "!node" ).params("-v").run( returnOutput=true )).len()){
            print.redline("nodejs must be installed for browsersync to work.  Sorry!");
            print.cyanline("https://nodejs.org/en/download/");
            print.cyanline("Once installed, open a command prompt and:");
            print.cyanline("npm install -g npm");
            print.cyanline("npm install -g gulp-cli");
            print.cyanline("OR, install nodejs, rerun browsersync and we'll install those for you!");
            return;
        } else {
            print.greenline("nodejs is installed!");
        }

        if (!reMatch("\d+.\d+.\d+",command( "!npm -v || echo nouhuh" ).run( returnOutput=true )).len()){
            if (confirm( "npm needs to be updated - do you want me to do that for you? (y/n)" ) ) {
                print.greenline( "Updating npm" );
                command( "!npm" ).params( "install", "-g", "npm" ).run();
            } else {
                print.cyanline("Please run 'npm install -g npm' then rerun browsersync");
                return
            }
        } else {
            print.greenline("npm is up to date!");
        }

        if (!reMatch("^CLI version:",command( "!gulp -v || echo nouhuh" ).run( returnOutput=true )).len()){
            if (confirm( "gulp needs to be installed - do you want me to do that for you? (y/n)" ) ) {
                print.greenline( "Installing gulp" );
                command( "!npm" ).params( "install", "-g", "gulp-cli" ).run();
            } else {
                print.cyanline("Please run 'npm install -g gulp-cli' then rerun browsersync");
                return
            }
        } else {
            print.greenline("gulp is installed!");
        }

        if (!directoryExists(resolvepath("./node_modules/browser-sync" )) || !directoryExists(resolvepath("./node_modules/gulp" ))){
            outPath = "#this.basePath#/package.json";
            file action="write" file="#outPath#" mode="777" output="#fileRead( '/commandbox-browsersync/package.json' )#";

            if (confirm( "We need to install the local libraries - do you want me to do that for you? (y/n)" ) ) {
                print.greenline( "Installing local libraries " );
                command( "!npm" ).params( "install").run();
            } else {
                print.cyanline("Please run 'npm install");
                return
            }
        } else {
            print.greenline("Local libraries appear intact! Moving forward...");
        }

        if (!serverRunning()){
            if (confirm( "We need to start the webserver - do you want me to do that for you? (y/n)" )){
                command( "server start" ).run();
                while (!serverRunning()){
                    print.text(".");
                    sleep(1000);
                }
            } else {
                print.redline( "OK :(  Please start the server and then rerun browsersync." );
                return;
            }
        }

        var serverPort = deserializeJSON(fileRead( resolvepath("./server.json" ))).web.http.port;

        var gulpfile = fileRead( "/commandbox-browsersync/templates/gulpfile.js" );

        outPath = "#this.basePath#gulpfile.js";

        file action="write" file="#outPath#" mode="777" output="#replaceNoCase( gulpfile, "|serverPort|", serverPort, "all" )#";
        print.greenLine( "Created #outPath#" );
        print.greenLine( "Launching..." );
        command( "!gulp" ).run();

        //coldbox watch-reinit paths= "config/**.cfc,handlers/**.cfc,models/**.cfc";
    }

    function serverRunning(){
        var running = command( "server status" ).run( returnOutput=true );
        echo(running);
        return reMatch("running",running).len();
    }
}