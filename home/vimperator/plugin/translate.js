// Vimperator Plugin: 'Google Translate'
// Last Change: 20-Feb-2010
// License: MIT
// Maintainer: Max Sukharev <max@smacker.ru>
// URL: http://launchpad.com/~cyxapeff/+junk/vimperator-translate
// Usage: Use :translate [-l from|to] text

commands.addUserCommand(["tr[anslate]"],
    "Translate text using google translate",
    function (args)
    {
    if (!args['-langpair'] || args["-langpair"].lenght == 0)
    {
	var langpair = typeof liberator.globalVariables.translate_langpair == "undefined" ?
                   "en|zh" : liberator.globalVariables.translate_langpair;
    } else {
        langpair = args["-langpair"];
    }
    util.httpGet ("http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=" + encodeURIComponent(args.join(" ")) + "&langpair=" + encodeURIComponent(langpair), 
        function (req)
        {
            if (req.status == 200)
            {
                var json = eval('('+ req.responseText +')');
                liberator.echo("Translate: " + json.responseData.translatedText);}
            else
            liberator.echoerr("Error contacting googleapis!\n");
        }
    );
    }, {
        options: [[["-langpair", "-l"], commands.OPTION_STRING]]
    }

);
