function ports -d "List processes listening on various ports"
    sudo lsof -iTCP -sTCP:LISTEN -P -n
end
