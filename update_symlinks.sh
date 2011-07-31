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
base=false

for dotfile in ~/dotfiles/home/* ; do
  base=`basename $dotfile`
  rm ~/.$base
  ln -s $dotfile ~/.$base
done
