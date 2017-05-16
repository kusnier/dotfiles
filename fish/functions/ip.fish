function ip -d "ip" --wraps "dig"
    dig +short myip.opendns.com @resolver1.opendns.com
end
