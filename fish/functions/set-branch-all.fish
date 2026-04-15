function set-branch-all
    set branch $argv[1]
    for dir in (ls -d */)
        if test -d $dir/.git
            echo "Checking out or creating branch '$branch' in $dir"
            cd $dir
            if git rev-parse --verify $branch > /dev/null 2>&1
            git checkout $branch
            else
                git checkout -b $branch
        end
            cd ..
    end
end
end
