function ccat -d "Colored cat" --wraps "phymetize"
    pygmentize $argv[1]
end
