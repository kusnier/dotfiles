function fix-open-with -d "Fix the shitty OS X Open With menu duplicates"
    /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain user
    killall Finder
    echo "Open With has been rebuilt, Finder will relaunch"
end


