# Vim settings

## Bindings

### Tags
Add these lines in vimrc

    map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
    map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

* C-] - go to definition
* C-T - Jump back from the definition
* C-W C-] - Open the definition in a horizontal split
* C-\ - Open the definition in a new tab
* A-] - Open the definition in a vertical split
* Ctrl-Left_MouseClick - Go to definition
* Ctrl-Right_MouseClick - Jump back from definition

### Buffder / Tab / Window

* C-w T - to change that split into a new tab.

_Todo_

1. Add all used bindings
2. mark bindings with [frequently used|tolearn|useless]

## Plugins

_Todo_

1. Add used plugins with author/links
