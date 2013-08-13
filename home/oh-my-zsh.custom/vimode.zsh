function zle-line-init zle-keymap-select {
    local normal insert
    insert="%{$fg[yellow]%}%{$fg[black]$bg[yellow]%} INSERT %{$reset_color%}"
    normal="%{$fg[green]%}%{$fg[black]$bg[green]%} COMMAND %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/${normal}}/(main|viins)/${insert}}"
    RPS2=$RPS1
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# Remove any right prompt, show only the last mode
setopt transientrprompt
