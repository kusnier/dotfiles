function ag -d "Run Ag with appropriate options." --wraps "ag"
    if begin test -f '.agignore'; and grep -q 'pragma: skipvcs' '.agignore'; end
        # If .agignore contains pragma: skipvcs, then we'll run ag in
        # "disregard .gitignore/.hgignore/svn:ignore" mode.  This lets us
        # still search in files the VCS has ignored.
        command ag --search-files -U $argv
    else
        command ag --search-files $argv
    end
end
