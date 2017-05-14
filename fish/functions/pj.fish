function pj -d "Prettify JSON"
    if test "$argv[1]" = "-C"
        # no color
        python -m json.tool
    else
        python -m json.tool | pygmentize -l json
    end
end

