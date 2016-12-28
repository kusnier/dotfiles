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
#export MANPAGER="sh -c \"col -bx | iconv -c | view -c 'set ft=man nomod nolist titlestring=MANPAGE' -\""
export PAGER=vimpager
export MANPAGER=vimpager

# cd options
export FIGNORE='.svn'

export FCEDIT='vim -g -f'

# java
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

# groovy
export GROOVY_HOME=/usr/local/opt/groovy/libexec

# jboss
#export JBOSS_HOME=/usr/local/opt/jboss-as/libexec
export JBOSS_HOME=/usr/local/opt/wildfly-as/libexec
export PATH=${PATH}:${JBOSS_HOME}/bin

# gnu-tar
PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
