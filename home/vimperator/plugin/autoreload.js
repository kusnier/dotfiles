// small Vimperator plugin to add command to refresh page in a loop
//
// TODO: add some verbose feedback 
// TODO: fix :stopautore command (needs more testing)?
// DONE: autoreload in background (don't follow current tab)

var ONESEC = 1000; // 1000ms
var ONEMIN = 60 * ONESEC; // 60s
var INTERVAL = ONEMIN; // 1m

var _TAB_TO_AUTORELOAD;
var _INTERVAL_ID; 

// add vimperator command
commands.addUserCommand(["autoreload"],
	"start auto reload of current tab every [N] seconds",
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
			_TAB_TO_AUTORELOAD = getBrowser().selectedTab;
			liberator.echo("reloading every " + rlimit + " seconds tab with title: " + _TAB_TO_AUTORELOAD.label );
			_INTERVAL_ID = window.setInterval( function(){ getBrowser().reloadTab( _TAB_TO_AUTORELOAD ); }, INTERVAL );
		}
		else
		{
			liberator.echoerr("unnacceptable interval. Must be a miniumum of 3 seconds");
			//window.setTimeout( function(){ ; },0); 
		}
	},
	{ argCount: "1" }
);

// add vimperator command
commands.addUserCommand(["stopautore"],
	"stop auto reload of previously selected tab",
	function (args)
	{
		window.clearInterval( _INTERVAL_ID );
	},
	{ argCount: "0" }
);
