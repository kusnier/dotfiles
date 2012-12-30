## Open current directory
alias oo='open .'

# List direcory contents
alias l1='tree --dirsfirst -ChFL 1'
alias l2='tree --dirsfirst -ChFL 2'
alias l3='tree --dirsfirst -ChFL 3'

alias ll1='tree --dirsfirst -ChFupDaL 1'
alias ll2='tree --dirsfirst -ChFupDaL 2'
alias ll3='tree --dirsfirst -ChFupDaL 3'

# mkdir & cd to it
function mcd() { 
  mkdir -p "$1" && cd "$1"; 
}
