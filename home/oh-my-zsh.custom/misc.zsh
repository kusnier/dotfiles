## pretty man pages
function pman() {
    man $1 -t | open -f -a Preview
}
#
## pretty JSON
function pj() {
    python -mjson.tool
}

## Quick-look a file (^C to close)
alias ql='qlmanage -p 2>/dev/null'

# Quick and dirty encryption
function encrypt() {
    openssl des3 -a -in $1 -out $1.des3
}
function decrypt() {
    openssl des3 -d -a -in $1 -out ${1%.des3}
}
