// small Vimperator plugin to add command to refresh page in a loop
//
// TODO: add some verbose feedback 
// TODO: fix :stopautore command (needs more testing)?
// TODO: autoreload in background (don't follow current tab)

// set some global constants

var ONESEC = 1000; // 1000ms
var ONEMIN = 60 * ONESEC; // 60s
var INTERVAL = ONEMIN; // 1m

function AutoReloadPageVimperator(args)
{
    window.setTimeout(
	    function()
	    {
		//window.location.reload() ; // WARNING: destroys all open tabs
		// if (doc == getBrowser().contentDocument)
		liberator.modules.tabs.reload(getBrowser().mCurrentTab) ;
		// prevent infinite looping from happening
		if (INTERVAL > 2000 )
		{
			AutoReloadPageVimperator(args) ;
		}
	    },
	    INTERVAL
    ) ;
    //LastLoaded = new Date().toLocaleFormat("%x %X");
    //liberator.echoerr("page last reloaded at: " + LastLoaded);
}

// add vimperator command
commands.addUserCommand(["autoreload"],
	"start auto reload of current page every [N] seconds",
	function (args)
	{ 
		var rlimit = args.string;
		var rlimit = parseInt(rlimit, 10);
		INTERVAL = rlimit * ONESEC; // how often to refresh page (in seconds)

		if (!rlimit && rlimit != 0)
		{
			liberator.echoerr("must enter an acceptable numeric value");
			return;
		}

		if (rlimit && rlimit > 2)
		{
			liberator.echo("reloading page every " + rlimit + " seconds");
			AutoReloadPageVimperator(rlimit);
		}
		else
		{
			liberator.echoerr("unnacceptable interval. must be a miniumum of 3");
			windows.setTimeout( function(){ ; },0); 
		}
	},
	{ argCount: "1" }
);

// add vimperator command
commands.addUserCommand(["stopautore"],
	"stop auto reload of current page",
	function (args)
	{
		INTERVAL = 0 * ONESEC; // how often to refresh page (in seconds)

		liberator.echo("stopping autoreload of current page");
		windows.setTimeout( function(){ ; },0); 
	},
	{ argCount: "0" }
);
