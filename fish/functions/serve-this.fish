function serve-this -d "Launch a webserver on 8000 serving the cwd"

    set port 8000

    if test "$argv[1]" != ""
        set port $argv[1]
    else
        set port 8000
    end

    echo "Open browser: http://localhost:$port/"
    python3 -m http.server
    open "http://localhost:$port/"
    fg
end
