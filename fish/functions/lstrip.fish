function lstrip -d "Strip whitespace from the left of each line"
    sed -Ee 's/^[[:space:]]*//'
end

