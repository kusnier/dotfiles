function rstrip -d "Strip whitespace from the right of each line"
    sed -e 's/[[:space:]]*$//'
end
