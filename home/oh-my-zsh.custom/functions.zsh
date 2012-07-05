# Create a data URL from an image (works for other file types too, if you tweak the Content-Type afterwards)
dataurl() {
echo "data:image/${1##*.};base64,$(openssl base64 -in "$1")" | tr -d '\n'
}

# Gzip-enabled `curl`
function gurl() {
curl -sH "Accept-Encoding: gzip" "$@" | gunzip
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
  inotifywait -e modify -e move -e create -e delete \
    -r -m . | while read line ; do
    dsync
  done
}

function cur_svn_revision() {
  svn info | grep Revision: | cut -d' ' -f2
}
