function clonedown -d "clone a repo down"
    cd ~/src
    git clone $argv
    cd (echo "$argv" | sed -Ee 's_.*/__')
end
