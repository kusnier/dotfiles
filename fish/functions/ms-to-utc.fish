function ms-to-utc -d "convert epoch milliseconds to UTC"
    date -ur (echo -n $argv[1] | sed -e 's/...$//')
end
