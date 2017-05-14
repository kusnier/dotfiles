function fzf-fish
  set -q FZF_FIND_FILE_COMMAND
  or set -l FZF_FIND_FILE_COMMAND "ffind --semi-restricted --depth=15 --follow"
  fish -c "$FZF_FIND_FILE_COMMAND" | fzf -m --height 15 | read -l selects
  and commandline -i "\"$selects\""
  commandline -f repaint
end

# https://github.com/fisherman/fzf/blob/master/key_bindings.fish
