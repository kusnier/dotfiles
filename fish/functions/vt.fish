function vt -d "Open file in remote tab" --wraps "vim"
    vim -g --remote-tab-silent $argv
end
