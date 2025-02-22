function pull-all
    for dir in (find . -type d -name .git -prune -exec dirname {} \;)
        echo "Pulling in $dir"
        cd $dir; and git pull &; cd - > /dev/null
    end
    wait
end