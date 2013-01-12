function zle-line-init zle-keymap-select {
    local normal insert
    insert="%{%K{226}%}%{%F{black}%}"
    normal="%{%K{green}%}%{%F{black}%}"
    RPS1="${${KEYMAP/vicmd/${normal}[N]}/(main|viins)/${insert}[I]}"
    RPS2=$RPS1
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
