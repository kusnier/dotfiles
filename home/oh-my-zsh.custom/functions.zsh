# Create a data URL from an image (works for other file types too, if you tweak the Content-Type afterwards)
dataurl() {
echo "data:image/${1##*.};base64,$(openssl base64 -in "$1")" | tr -d '\n'
}

# Gzip-enabled `curl`
function gurl() {
curl -sH "Accept-Encoding: gzip" "$@" | gunzip
}

# Simple calculator
function calc() {
  local result=""
  result="$(printf "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')"
  #                       └─ default (when `--mathlib` is used) is 20
  #
  if [[ "$result" == *.* ]]; then
    # improve the output for decimal numbers
    printf "$result" |
    sed -e 's/^\./0./'        `# add "0" for cases like ".5"` \
        -e 's/^-\./-0./'      `# add "0" for cases like "-.5"`\
        -e 's/0*$//;s/\.$//'   # remove trailing zeros
  else
    printf "$result"
  fi
  printf "\n"
}

# http://ku1ik.com/2012/05/04/scratch-dir.html
function new-scratch {
  new_dir="/tmp/scratch-`date +'%s'`"
  [ -d "/dev/shm/" ] && new_dir="/dev/shm/scratch-`date +'%s'`"

  cur_dir="$HOME/scratch"
  mkdir -p $new_dir
  ln -nfs $new_dir $cur_dir
  cd $cur_dir
  echo "New scratch dir ready for grinding ;>"
}

# Determine size of a file or total size of a directory
function fs() {
  if du -shb /dev/null > /dev/null 2>&1; then
    local arg=-sbh
  else
    local arg=-skh
  fi
  if [[ -n "$@" ]]; then
    du $arg -- "$@"
  else
    du $arg .[^.]* *
  fi
}

# Switch between vm.box and host
function dswitch {
  cur_dir=$PWD
  if [[ $cur_dir =~ /share.devel/ ]]; then
    cd ${cur_dir/\/share.devel\//\/devel\/}
  elif [[ $cur_dir =~ /devel/ ]]; then
    cd ${cur_dir/\/devel\//\/share.devel\/}
  fi
}

# Rsync files between vm.box and host
function dsync {
  cur_dir=$PWD
  if [[ $cur_dir =~ /share.devel/ ]]; then
    target_dir=${cur_dir/\/share.devel\//\/devel\/}
  elif [[ $cur_dir =~ /devel/ ]]; then
    target_dir=${cur_dir/\/devel\//\/share.devel\/}
  fi
  rsync -av --delete $cur_dir/. $target_dir/.
}

function inotifydsync {
  inotifywait -e close_write -e move -e create -e delete \
    -r -m . | while read line ; do
    dsync
  done
}

function cur_svn_revision() {
  svn info | grep Revision: | cut -d' ' -f2
}

# Requirements: moreutils (spinge, vipe)
function hexedit() {
xxd $1 | vipe | xxd -r | sponge $1
}

# Trailing whitespace elimination function for multiple files
function xpcs_removetrailingspaces() {
  find . -type f -name "$1" -exec sed --in-place 's/[[:space:]]\+$//' {} \+
}

# xp:cs: No two consecutive empty lines
function xpcs_no_two_consecutive_empty_lines() {
  find . -type f -name "$1" -exec sed --in-place '/^$/N;/^\n$/D' {} \+
}

# xp:cs: One space after operator
function xpcs_one_space_after_operator() {
  find . -type f -name "$1" -exec sed --in-place 's/\(\S\)\([+<=]=\{1,2\}\)\(\S\)/\1 \2 \3/' {} \+
}

# xp:cs: One space after keyword
function xpcs_one_space_after_keyword() {
  foreach type ('throw' 'if' 'while' 'switch' 'for' 'foreach' );
    find . -type f -name "$1" -exec sed --in-place "s/\($type\)\((\)/\1 \2/" {} \+
  end
}

# xp:cs: Empty line before comment line
function xpcs_empty_line_before_comment_line() {
  find . -type f -name "$1" -exec vim +'set autowrite' +':bufdo XpcsEmptyLineBeforeCommentLine' {} \+
}

# xp:cs: One space after comma
function xpcs_one_space_after_comma() {
  find . -type f -name "$1" -exec sed --in-place 's/array(\(\w\+\),\(\w\+\)/array(\1, \2)/' {} \+
}

# svn

# show for each file a diff in vim
function svn_gdiff {
  foreach f (`svn st | cut -d' ' -f 8`); gvim -f $f +':normal ,cv'; end
}

# show for each file a diff in vim
function svn_gdiff_all {
  gvim --servername svn_diff
  foreach f (`svn st | cut -d' ' -f 8`);
    gvim --servername svn_diff --remote-tab $f
  end
  gvim --servername svn_diff --remote-send '<ESC>:tabdo :VCSVimDiff<CR>'
}

function is_svn_dir() {
  if [[ -d .svn ]]; then
      echo 1
  fi
}

function is_git_dir() {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    echo 1;
  fi
}

function vcs_up () {
  for dir in *; do
    if [ -d $dir ]; then
      pushd $dir &> /dev/null
      tput setaf 141
      echo "===> Update $dir"
      echo "$reset_color"
      [ $(is_svn_dir) ] && svn up
      [ $(is_git_dir) ] && git pull
      popd &> /dev/null
    fi
  done
}

function finder-clear-open-with() {
  /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain user
  killall Finder
  echo "Open With has been rebuilt, Finder will relaunch"
}

function port {
  local PORT=$1
  sudo lsof -iTCP:$PORT -sTCP:LISTEN
}
