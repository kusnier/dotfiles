#!/bin/bash
MODE="copy"

rm -r home/vim/bundle.merged/*
mkdir -p home/vim/bundle.merged/all;
cd home/vim/bundle
for d in *;do
  cd $d

  if [ $MODE == 'copy' ]; then
    #############################
    # Solution 1: Copy files
    cp -i -r * ../../bundle.merged/all
  fi

  if [ $MODE == 'hardlink' ]; then
    #############################
    # Solution 2: Hardlink files
    #   SRC directory is root of tree you want to replicate.
    #   It should *not* be an absolute pathname.
    SRC=.
    DSTDIR=../../bundle.merged/all

    # Replicate directory structure
    find $SRC -type d -exec mkdir -p $DSTDIR/{} \;

    # Make hard links to files
    find $SRC -type f -exec ln {} $DSTDIR/{} \;
  fi

  cd ..;
done

# Generate doc/tags file
vim -c ':helptags ../doc/'  -c ':helptags ../bundle.merged/all/doc/' -c ':q'

# Create a copy on /dev/shm
if [[ -d '/dev/shm' ]]; then
  cd ../bundle.merged/all
  rm -r /dev/shm/vim.bundle.merged/
  mkdir -p /dev/shm/vim.bundle.merged/all
  cp -R * /dev/shm/vim.bundle.merged/all
fi
