# Vim settings

## Must have :help

* `:help cmdline-special` - Ex special characters
* `:help ins-completion` - Insert mode completion

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

Ctags generation:

- for php `ctags -R --languages=php .`

Commands and bindings

Some of the tag match list commands:

* `C-]` - go to definition
* `g]` - Like `C-]`, but use ":tselect" instead of ":tag"
* `C-T` - Jump back from the definition
* `C-W C-]` - Open the definition in a horizontal split
* `C-\` - Open the definition in a new tab
* `A-]` - Open the definition in a vertical split
* `C-Left_MouseClick` - Go to definition
* `C-Right_MouseClick` - Jump back from definition
* `:tselect` - lists the tags that match its argument or keyword under the cursor
* `:stselect` - like :tselect but in a split
* `C-W g]` to a :tselect on cursor/selection
* `:tjump` - jump to tag or list if multiple tags found
* `:stjump` - like :tjump but opens in a new split
* `C-W g C-]` - like :stjump
* `g C-]` - like :tjump
* `:tnext`, `:tprevious`, `:tfirst` and `:tlast` jump through the tag occurrences
* the most ex command are support pattern, `:tag /<pattern>`

Some of the tag stack commands:

* `:pop` - jumps backward in the tag stack
* `:tag` - jumps forward in the tag stack
* `:tag XYZ<tab>` - tag support tag completion
* `:tags` - displays a tag stack
* `:stag` - like :tag but open a new split

Some of the tag preview commands:

* `:ptag` - open tag in a preview window, stay in current buffer 
* `Ctrl-W }` - like :ptag
* `:ptselect` - like :tselect but in a preview split
* `:ptnext`, `:ptprevious`, `:ptfirst` and `:ptlast` jump through the tag occurrences

Some of the search commands:

* `[i` and `]i` display the first line containing the keyword under and after the cursor
* `[I` and `]I` display all lines containing the keyword under and after the cursor
* `[ C-i` and `] C-i` jumps to the first line that contains the keyword under and after the cursor

* `:help tags-and-searches - Tags and special searches

### Taglist

* `,tl` - Show/Hide Taglist (:TlistToggle)

### Suptertab

* `:SuperTabHelp` - list all available completion types

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
