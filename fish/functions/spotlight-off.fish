function spotlight-off -d "Turn off Spotlight indexing"
    sudo mdutil -a -i off
    and sudo mv /System/Library/CoreServices/Search.bundle/ /System/Library/CoreServices/SearchOff.bundle/
    and killall SystemUIServer
end
