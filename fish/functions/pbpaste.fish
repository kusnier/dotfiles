function pbpaste
    if test (uname) = Darwin
        command pbpaste
    else
        xsel --clipboard --input
    end
end

alias tpaste="pbpaste"