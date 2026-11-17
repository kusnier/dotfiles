function pbcopy
    if test (uname) = Darwin
        command pbcopy
    else
        xsel --clipboard --input
    end
end

alias tcopy="pbcopy"