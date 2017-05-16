function vl -d "Open last modified file in vim" --wraps "vim"
    set lastModifiedFile (ls -t | head -1)
    vim $lastModifiedFile
end
