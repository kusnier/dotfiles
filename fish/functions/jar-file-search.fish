# Defined in /tmp/fish.HHtHTK/jar-file-search.fish @ line 2
function jar-file-search
	set PATTERN $argv
    for f in (ls ***.jar)
       echo "$f: "; unzip -l $f | grep "$PATTERN";
    end
end
