function set-master-all
    for dir in (ls -d */)
        if test -d $dir/.git
            echo "Setting master branch in $dir"
            cd $dir
            git checkout master
            cd ..
        end
    end
end