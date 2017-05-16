function svnup -d "Recusrive svn up" --wraps "svn"
    find . -depth -maxdepth 1 -type d -not -name '.svn' -exec svn up {} \;
end
