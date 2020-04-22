component {

    property name="serverService" inject="ServerService";

    function run(   number  proxyport = 3000,
                    boolean fwreinit = true
                ){

        this.basePath = resolvePath( "./");
        
        if (!reMatch("v\d+",command( "!node -v || echo notinstalled" ).run( returnOutput=true )).len()){
            print.redline("nodejs must be installed for browsersync to work.  Sorry!");
            print.cyanline("https://nodejs.org/en/download/");
            print.line("Once installed, open a command prompt and:");
            print.line("npm install -g npm");
            print.line("npm install -g gulp-cli");
            print.line("OR, install nodejs, rerun browsersync and we'll install those for you.");
            return;
        } else {
            print.greenline("nodejs is installed!");
        }

        if (!reMatch("\d+.\d+.\d+",command( "!npm -v || echo notinstalled" ).run( returnOutput=true )).len()){
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

        if (!reMatch("^CLI version:",command( "!gulp -v || echo notinstalled" ).run( returnOutput=true )).len()){
            if (confirm( "gulp-cli needs to be installed - do you want me to do that for you? (y/n)" ) ) {
                print.greenline( "Installing gulp-cli" );
                command( "!npm" ).params( "install", "-g", "gulp-cli" ).run();
            } else {
                print.cyanline("Please run 'npm install -g gulp-cli' then rerun browsersync");
                return
            }
        } else {
            print.greenline("gulp is installed!");
        }

        if ( !directoryExists(resolvepath("./node_modules/browser-sync" )) 
            || !directoryExists(resolvepath("./node_modules/gulp" ))
            || !directoryExists(resolvepath("./node_modules/axios" ))){
            if (confirm( "We need to install the local libraries - do you want me to do that for you? (y/n)" ) ) {
                
                if (!fileExists("#this.basePath#package.json")){
                    print.greenline( "No package.json found.  Adding..." );
                    outPath = "#this.basePath#package.json";
                    file action="write" file="#outPath#" mode="777" output="#fileRead( '/commandbox-browsersync/package.json' )#";
                }
                print.greenline( "Installing local libraries..." );
                command( "!npm" ).params( "install", "gulp", "browser-sync", "axios", "--save-dev").run();
            } else {
                print.cyanline("Please run 'npm install gulp browser-sync --save-dev");
                return
            }
        } else {
            print.greenline("Local libraries appear intact! Moving forward...");
        }

        if (!serverRunning()){
            if (confirm( "We need to start the webserver - do you want me to do that for you? (y/n)" )){
                command( "server start openbrowser=false" ).run();
                var tick = 0;
                while (!serverRunning() && tick < 15){
                    sleep(1000);
                    tick++;
                }
                sleep(2000);
            } else {
                print.redline( "OK :(  Please start the server and then rerun browsersync." );
                return;
            }
        }
        //print.blueline(command( "server status" ).run( returnOutput=true ));
        print.greenline("Server is running...");
        print.line();
        var serverDetails = serverService.resolveServerDetails( { directory : getCWD() } );
        if( serverDetails.serverIsNew ){
            error( "The server you requested was not found." );
        }
        var serverInfo = serverDetails.serverInfo;
        //print.line(serverInfo);
        var serverHost = serverInfo.host;
        var serverPort = serverInfo.port;
        var SSLport = serverInfo.SSLport;

        var gulpfile = fileRead( "/commandbox-browsersync/templates/gulpfile.js" );

        var outPath = "#this.basePath#gulpfile.js";

        var outFile = replaceNoCase( gulpfile, "|serverHost|", ((serverHost == "0.0.0.0") ? "127.0.0.1" : serverHost), "all" );
        outfile = replaceNoCase( outfile, "|serverPort|", serverPort, "all" );
        outfile = replaceNoCase( outfile, "|proxyPort|", proxyPort, "all" );

        if (arguments.fwreinit){
            print.greenline("We will be reinitializing the framework on core file changes.");
            outfile = replaceNoCase( outfile, "|paths|", fileRead( "/commandbox-browsersync/templates/reinit.js" ) );
        } else {
            print.blueline("We will not be reinitializing the framework on core file changes.");
            outfile = replaceNoCase( outfile, "|paths|", fileRead( "/commandbox-browsersync/templates/noreinit.js" ) );
        }
        
        print.line();
        file action="write" file="#outPath#" mode="777" output="#outfile#";
        print.greenLine( "Created #outPath#" );
        print.greenLine( "Launching..." );
        print.line();

        command( "!gulp" ).run();

        //coldbox watch-reinit paths= "config/**.cfc,handlers/**.cfc,models/**.cfc";
    }

    function serverRunning(){
        var running = command( "server status" ).run( returnOutput=true );
        //print.yellowLine(findNoCase("(running)",running));
        return findNoCase("(running)",print.unansi(running));
    }
}