function spotlight-tail -d "Watch what Spotlight is doing"
    sudo fs_usage -w -f filesys mdworker | grep "open"
end
