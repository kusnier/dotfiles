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

base=false
dotfilespath=$(realpath $0)

for dotfile in ${dotfilespath}/home/* ; do
  echo $dotfile
  base=`basename $dotfile`
  rm -ir ~/.$base
  ln -v -s $dotfile ~/.$base
done

