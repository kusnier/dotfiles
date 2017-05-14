function upper -d "uppercase input"
    gsed -e 's/./\U\0/g' $argv
end
