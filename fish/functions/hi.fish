function hi --argument pattern -d "Highlight a pattern in a stream of text"
    grep -E --color=always --line-buffered "$pattern|\$"
end

