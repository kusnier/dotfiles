function lower -d "lowercase input"
    gsed -e 's/./\L\0/g' $argv
end
