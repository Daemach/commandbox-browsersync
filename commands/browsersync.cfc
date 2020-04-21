component {

    function run(){

        this basePath = resolvePath( "./");
        var output = command( "!node" ).params("-v").run( returnOutput=true );
        print.redline(output);
        
        if (!reMatch("v\d+",output).len()){
            print.redline("nodejs must be installed for browsersync to work.  Sorry!");
            print.cyanline("https://nodejs.org/en/download/");
            print.cyanline("Once installed, open a command prompt and:");
            print.cyanline("npm install -g npm");
            print.cyanline("https://nodejs.org/en/download/");
            return;
        }

        if (!fileExists("#basePath#/gulpfile.js")){
            print yellowline("gulpfile ain't there")
        }
    }
}