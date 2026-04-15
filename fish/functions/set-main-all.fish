function set-main-all
    for dir in (ls -d */)
        if test -d $dir/.git
            echo "Setting main branch in $dir"
            cd $dir
            git checkout main
            cd ..
        end
    end
end