#!/bin/bash - 
#===============================================================================
#
#          FILE:  update_symlinks.sh
# 
#         USAGE:  ./update_symlinks.sh 
# 
#   DESCRIPTION:  Create symlinks in home
# 
#       CREATED: 31.07.2011 13:36:05 CEST
#===============================================================================

set -o nounset                              # Treat unset variables as an error

function realpath() {
  # Get absolute path of the script (because of different readlink in macos)
  dir=`dirname $1`            # The directory where the script is 
  pushd "$dir" > /dev/null    # Go there
  callerpath=$PWD             # Record the absolute path
  popd > /dev/null            # Return to previous dir
  echo $callerpath
}

usage()
{
cat << EOF
usage: $0 options

This script updates the dotfile symlinks

OPTIONS:
   -h      Show this message
   -f      Overwrite existing files
EOF
}

base=false
force=false

while getopts "hf" OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         f)
             force=true
             ;;
         ?)
             usage
             exit 1
             ;;
     esac
done

if [[ "$force" = 'true' ]]; then
  rmopts=
else
  rmopts='-i'
fi

# ensure we're on the base of the dotfiles repo
dotfilespath="$(git rev-parse --show-toplevel)" || exit

for dotfile in ${dotfilespath}/home/* ; do
  echo $dotfile
  base=`basename $dotfile`
  rm $rmopts -r $HOME/.$base
  ln -v -s $dotfile $HOME/.$base
done

