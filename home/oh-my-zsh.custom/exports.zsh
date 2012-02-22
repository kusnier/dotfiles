# History
# Remove duplicate of previous line
export HIST_IGNORE_DUPS=1
# Don’t store lines starting with space
export HIST_IGNORE_SPACE=1

# Very long history file
export HISTSIZE=5000000
export HISTFILESIZE=$HISTSIZE

# Mysql
export MYSQL_PS1="\\d@\\h> "

# Man
# man pager: more info -> http://vim.wikia.com/wiki/Using_vim_as_a_man-page_viewer_under_Unix
export MANPAGER="sh -c \"col -bx | iconv -c | view -c 'set ft=man nomod nolist titlestring=MANPAGE' -\""
[[ -x `which vimpager` ]] && export PAGER=vimpager
[[ -x `which vimpager` ]] && export MANPAGER=vimpager

# cd options
export FIGNORE='.svn'
