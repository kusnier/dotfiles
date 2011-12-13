# Vim settings

## Must have :help

* `:help cmdline-special` - Ex special characters
* `:help ins-completion` - Insert mode completion

## Bindings

### General

* `,l` - Toggle invisibles
* `,p` - Toggle paste mode
* `<ESC>` - Clear search highlight
* `,W` - Strip all trailing whitespace in buffer
* `:Hammer` - Preview markup file in browser
* `<C-w>o` - Make the current window the only one on the screen

### Command-line

#### History

* `q:` - Open Ex command-line history
* `q/` or `q?` - Open search string history

### Splits

* `+` Increase split size.
* `-` Decrease split size.
* `<C-j>` Go to split below.
* `<C-k>` Go to split above.
* `<C-h>` Go to split left.
* `<C-l>` Go to split right.

### Diff

* `:diffthis` - Make the current window part of the diff windows

### Text manipulation

* `gU{motion}` - Make {motion} text uppercase.
* `gUU` - Make current line uppercase.
* `gu{motion}` - Make {motion} text lowercase.
* `guu` - Make current line lowercase.
* `g~{motion}` - Switch ase of {motion} text.
* `g~~` - Switch case of current line.

### phpDocumentor

* `<C-d>` - Generate php doc (current pos, range)

### Rainbow Parenthesis

* `,rp` Toggle RainbowParenthesis

### UltiSnips

* `<tab>` - Expand snippet
* `<C-tab>` - List snippets for current word
* `<C-j>` - next tabstops mark
* `<C-k>` - previous tabstops mark

### notes.vim

* `:Note` - starting a new note
* `:write` or `:update` - saving notes
* `:Note <anything>` - edit existing notes or create if no notes are found
* `:DeleteNote` - delete current note
* `:SearchNotes` - searching notes
* `:RelatedNotes` - find all notes referencing the current file
* `:RecentNotes` - lists notes by modification date
* `gf` - navigation between notes
* automatic curly quotes, arrows and list bullets
* completion of note titles using `C-x C-u`
* completion of tags using `C-x C-o`

### CtrlP

* `<C-p>` - to invoke CtrlP
* `:CtrlP` - Open CtrlP in find file mode.
* `:CtrlPBuffer` - Open CtrlP in find buffer mode.
* `:CtrlPMRU` - Open CtrlP in find Most-Recently-Used file mode.
* `:CtrlPTag` - Search for a tag within a generated central tags file
* `:CtrlPQuickfix` - Search for an entry in the current quickfix errors and jump to it.
* `:CtrlPDir` - Search for a directory and change the working directory to it.

Once CtrlP is open:

* `<C-k>` - up
* `<C-j>` - down
* `<C-n>` - history back
* `<C-p>` - history forward
* `<cr>` - open in current buffer
* `<C-s>` - open in new split/window
* `<C-t>` - open in new tab
* `<C-v>` - open in new vertical split
* `<C-f>` - next type
* `<C-b>` - previous type
* `<C-z>` - mark to open
* `<C-o>` - open marked files
* `<C-r>` - toggle between the string mode and full regexp mode
* `<C-d>` - toggle between full path search and filename only search
* `<C-u>` - clear the input field
* `F5` - clear file cache
* `<C-y>` - open new file
* other useful bindings: `<C-a>, <C-e>, <C-h>, <C-l>`
* cycle through the lines with the first letter that matches that key

Bindings for the CtrlPDir view

* `<cr>`  - Change the local working directory for CtrlP and keep it open.
* `<c-t>` - Change the global working directory (exit).
* `<c-v>` - Change the local working directory for the current window (exit).
* `<c-x>` - Change the global working directory to CtrlP’s current local
            working directory (exit).

Input Formats

* Simple String
* Vim regex
* End the string with a colon ':' followed by a Vim command to execute that
* `..` go backward in the directory tree
* `/` or `\` find and got tot to the project's root

### autoclose / delimitMate

Autoclose is disabled now. Testing delimitMate (new and on git).

* `<leader>a` - Toogle autoclose/delimitMate

### Buffder / Tab / Window

* `C-w T` - to change that split into a new tab.

### Tags

Add these lines in vimrc

```vim
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
```

Ctags generation:

- for php `ctags -R --languages=php .`
- for file lists (project.pth) use `ctags -R -L <filelist>`

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
* with 'wildmenu' option the most tag command display a list of matching tags

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

* `,tl` - Show/Hide Taglist

### Tagbar

* `,tb` - Show/Hide Tagbar
* `s` -  Reorder the items by alpha or occurance
* `<space>` - Show tag prototype in command line
* `<C-n>` - Go to the next top-level tag
* `<C-p>` - Go to the previous top-level tag
* `x` - Toggle zooming the window
* `q` - Close the Tagbar window

### TagMan

* `,tm` - Toggle the TabMan window in the current tab
* `,ftm` - Give focus to the TabMan window in the current tab

### NerdTree

* `,nt` - Show/Hide NerdTree
* `,nmt` or `:NERDTreeMirror` - Shares an existing NERD tree (other tab)
* `,nft` or `:NERDTreeFind` - Find the current file in the tree
* `:Bookmark <name>` - Bookmark the current node
* `:BookmarkToRoot <bookmark>` - Open bookmarked dir as new root

Bindings in NerdTree window:

* `C` - Make a node the current working directory
* `B` - Toggle the bookmark menu
* `A` - Zoom (maximize/minimize) the NERDTree window
* `u` - Move the tree root up one directory
* `U` - Same as 'u' except the old root node is left open
* `r` - Recursively refresh the current directory
* `R` - Recursively refresh the current root
* `m` - Display the NERD tree menu
* `cd` - Change the CWD to the dir of the selected node

Filter bindings

* `B` - Toggle whether the bookmark table is displayed
* `I` - Toggle whether hidden files displayed
* `f` - Toggle whether the file filters are used
* `F` - Toggle whether files are displayed

Open/Edit bindings

* `o` - Open files, directories and bookmarks
* `go` - Open selected file, but leave cursor in the NERDTree
* `t` - Open selected node/bookmark in a new tab
* `T` - Same as 't' but keep the focus on the current tab
* `i` - Open selected file in a split window
* `gi` - Same as i, but leave the cursor on the NERDTree
* `s` - Open selected file in a new vsplit
* `gs` - Same as s, but leave the cursor on the NERDTree
* `O` - Recursively open the selected directory
* `x` - Close the current nodes parent
* `X` - Recursively close all children of the current node
* `e` - Edit the current dif

Jump bindings

* `P`  - Jump to the root node
* `p` - Jump to current nodes parent
* `K` - Jump up inside directories at the current tree depth
* `J` - Jump down inside directories at the current tree depth
* `<C-J>` - Jump down to the next sibling of the current directory
* `<C-K>` - Jump up to the previous sibling of the current directory

### Suptertab

* `:SuperTabHelp` - list all available completion types

### Session

The session command supports completion

* `:OpenSession <name>` - Open a saved session
* `:SaveSession <name>` - Save this/new session
* `:ColseSession` - Close session
* `:DeleteSession` - Delete session
* `:ViewSession <name>` - View the Vim cript generated for a session
* `:RestartVim` - Save current editing session, restart vim and restore the session
* `$gvim --servername name` - Start vim and open session if exists

### vim-fugitive

#### Screencasts

* [A complement to command line git](http://vimcasts.org/e/31)
* [Working with the git index](http://vimcasts.org/e/32)
* [Resolving merge conflicts with vimdiff](http://vimcasts.org/e/33)
* [Browsing the git object database](http://vimcasts.org/e/34)
* [Exploring the history of a git repository](http://vimcasts.org/e/35)

#### Commands

* `:Gwrite` Stage the current file to the index
* `:Gread` Revert current file to last checked in version
* `:Gremove` Delete the current file and the corresponding Vim buffer
* `:Gmove` Rename the current file and the corresponding Vim buffer
* `:Gcommit` Opens up a commit window in a split
* `:Gblame` Opens a vertically split window containing annotations
* `:Gsplit! log` Opens the commit log in a split
* `:Gbrowse` open the current file on GitHub (or git instaweb)

### easymotion

Tutorial: <http://net.tutsplus.com/tutorials/other/vim-essential-plugin-easymotion/>

```vim
let g:EasyMotion_leader_key='\'
```

* `<Leader>f{char}` - Find {char} to the right.
* `<Leader>F{char}` - Find {char} to the left.
* `<Leader>t{char}` - Till before the {char} to the right.
* `<Leader>T{char}` - Till after the {char} to the left.
* `<Leader>w` - Beginning of word forward.
* `<Leader>W` - Beginning of WORD forward.
* `<Leader>b` - Beginning of word backward.
* `<Leader>B` - Beginning of WORD backward.
* `<Leader>e` - End of word forward.
* `<Leader>E` - End of WORD forward.
* `<Leader>ge` - End of word backward.
* `<Leader>gE` - End of WORD backward.
* `<Leader>j` - Line downward.
* `<Leader>k` - Line upward.

### Indent guides

* `<Leader>ig` - Toogle indent guides

## Plugins

_Todo_

1. Add used plugins with author/links
