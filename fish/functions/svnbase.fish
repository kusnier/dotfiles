function svnbase -d "Diff head to base" --wraps "svn"
    svn diff -rBASE:HEAD
end
