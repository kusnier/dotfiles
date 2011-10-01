var INFO = 
<plugin name="goo.gl url shorter" version="0.1"
        href="http://goo.gl/ZNzl"
        summary="goo.gl url shorter">
    <author email="angel2s2ru@gmail.com" href="http://angel2s2.blogspot.com/">Roman (Angel2S2) Shagrov</author>
    <license href="http://opensource.org/licenses/mit-license.php">MIT</license>
    <project name="Vimperator" minVersion="2.0" maxVersion="2.2"/>
    <description>
        Goo.gl an url and copy it to clipboard
        <ul>
            <li>:gg  - shorten url and copy to clipboard</li>
        </ul>
    </description>
</plugin>;

/*
Плагин основан на tr.im script (http://goo.gl/PPKQ) и статье с хабра (http://goo.gl/qI9N).

Благодарности:
_GaSh_     - http://linsovet.com/blogs/gash
о_О Тынц   - http://o-o-tync.livejournal.com/
*/

commands.addUserCommand ("gg", "Goo.gl an url and copy it to clipboard",
    function (args) {
        if (args[0] && args[0] != '' ) { 
			var url = args[0]; 
		} else { 
			var url = buffer.URL; 
		}
        util.httpGet ("http://ggl-shortener.appspot.com/?url="+encodeURIComponent (url), function (req) {
			if (req.status == 200) {
				util.copyToClipboard(req.responseText.split('"')[3]);
				liberator.echo("Yanked " +req.responseText.split('"')[3]);
			} else liberator.echoerr("Error contacting goo.gl!\n");
        });
    }
);

/* vim:se sts=4 sw=4 et: */
