#!/bin/bash
MODE="copy"

mkdir home/vim/bundle.merged;
rm -r home/vim/bundle.merged/*
cd home/vim/bundle
for d in *;do
  cd $d

  if [ $MODE == 'copy' ]; then
    #############################
    # Solution 1: Copy files
    cp -i -r * ../../bundle.merged
  fi

  if [ $MODE == 'hardlink' ]; then
    #############################
    # Solution 2: Hardlink files
    #   SRC directory is root of tree you want to replicate.
    #   It should *not* be an absolute pathname.
    SRC=.
    DSTDIR=../../bundle.merged

    # Replicate directory structure
    find $SRC -type d -exec mkdir -p $DSTDIR/{} \;

    # Make hard links to files
    find $SRC -type f -exec ln {} $DSTDIR/{} \;
  fi

  cd ..;
done

# Generate doc/tags file
vim -c ':helptags ../bundle.merged/doc/' -c ':q'

# Create a copy on /dev/shm
if [[ -d '/dev/shm' ]]; then
  cd ../bundle.merged
  mkdir -p /dev/shm/vim.bundle.merged
  rm -r /dev/shm/vim.bundle.merged/*
  cp -R * /dev/shm/vim.bundle.merged
fi
