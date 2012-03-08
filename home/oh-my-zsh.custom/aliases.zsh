# My aliases
alias c='clear'
alias v="vim"
alias gv="gvim"
alias gvim="gvim --remote-tab-silent"
alias mvim="mvim --remote-tab-silent"

# Use MacVim in terminal too
# or: brew install macvim --override-system-vim
[[ -x `which mvim` ]] && alias vim="mvim -v"

#Suffix aliases
# filename.md pressing return-key starts gvim
alias -s md=gvim
alias -s html=gvim
alias -s php=gvim
alias -s js=gvim

# On linux use open like in macos
[[ `uname -s` == 'Linux' ]] && alias open=xdg-open

# some more ls aliases
alias la='ls -A'

# List only directories
alias lsd='ls -l | grep "^d" --color=never'

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias dir='ls --color=auto --format=vertical'
    alias vdir='ls --color=auto --format=long'
    alias l.='ls -d .* --color=auto'
fi

if [ "$TERM" != "dumb" ]; then
    alias grep='grep --color=auto --exclude="*.svn" --exclude="*.svn-base"'
    alias fgrep='fgrep --color=auto --exclude="*.svn" --exclude="*.svn-base"'
    alias egrep='egrep --color=auto --exclude="*.svn" --exclude="*.svn-base"'
    alias diff=colordiff
fi

# vim
# edit last modified file
alias vl="vim `ls -t | head -1`"
alias less=$PAGER

# ps
alias psg="ps -aux ¦ grep bash"

#To navigate to the different directories
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias -- -="cd -"

# svn
alias svnup='find . -depth -maxdepth 1 -type d -not -name '.svn' -exec svn up {} \;'

# git
# Undo a `git push`
alias undopush="echo Use new git alias: git undopush"
alias undocomit="git reset --soft HEAD^"
# choose changes for staging
alias gap="git add --patch"

# diff
alias wdiff="wdiff -n -w $'\033[30;41m' -x $'\033[0m' -y $'\033[30;42m' -z $'\033[0m'"

# tcpdump
alias tdump="tcpdump -i eth0 port not `echo $SSH_CLIENT | awk '{print $2}'`"
alias httpdump="sudo tcpdump -i en0 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# lwp-request - Simple command line user agent
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "$method"="lwp-request -m '$method'"
done

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias digfull="dig +nocmd $1 any +multiline +noall +answer"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# lpr
alias lpr_a4="lpr -o media=A4 -o fitplot=true"

# vim aliases
alias vtag='gvim -t'

alias wget-mirror="wget -e robots=off --timestamping --recursive --level=inf --no-parent --page-requisites --convert-links --backup-converted"
alias wget-fullpage="wget -e robots=off --page-requisites --span-hosts --convert-links"

#How to temporarily stop using aliases
#When you want to call the command instead of the alias, then you have to escape it and call.
# $ \aliasname

if [[ `uname -s` == 'Darwin' ]]; then 
  alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
  alias wlan_scan="airport -s"
fi

alias random_mac="ruby -e 'puts (\"%02x\"%((rand 64)*4|2))+(0..4).inject(\"\"){|s,x|s+\":%02x\"%(rand 256)}'"
alias set_random_mac="echo sudo ifconfig en0 ether $(random_mac)"
