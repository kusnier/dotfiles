# Vim settings

## Bindings

### autoclose / delimitMate

Autoclose is disabled now. Testing delimitMate (new and on git).

* `<leader>a` - Toogle autoclose/delimitMate

### Buffder / Tab / Window

* `C-w T` - to change that split into a new tab.

### Tags
Add these lines in vimrc

    map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
    map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

* `C-]` - go to definition
* `g]` - Like `C-]`, but use ":tselect" instead of ":tag"
* `C-T` - Jump back from the definition
* `C-W C-]` - Open the definition in a horizontal split
* `C-\` - Open the definition in a new tab
* `A-]` - Open the definition in a vertical split
* `C-Left_MouseClick` - Go to definition
* `C-Right_MouseClick` - Jump back from definition
* `:tag XYZ<tab>` - tag support tag completion
* `:help tags-and-searches - Tags and special searches


### vim-fugitive

* `:Gwrite` Stage the current file to the index
* `:Gread` Revert current file to last checked in version
* `:Gremove` Delete the current file and the corresponding Vim buffer
* `:Gmove` Rename the current file and the corresponding Vim buffer
* `:Gcommit` Opens up a commit window in a split
* `:Gblame` Opens a vertically split window containing annotations
* `:Gsplit! log` Opens the commit log in a split
* `:Gbrowse` open the current file on GitHub (or git instaweb)


_Todo_

1. Add all used bindings
2. mark bindings with [frequently used|tolearn|useless]

## Plugins

_Todo_

1. Add used plugins with author/links
