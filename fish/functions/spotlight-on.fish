function spotlight-on -d "Turn on Spotlight indexing"
    sudo mdutil -a -i on
    and sudo mv /System/Library/CoreServices/SearchOff.bundle/ /System/Library/CoreServices/Search.bundle/
    and killall SystemUIServer
end
