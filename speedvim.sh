#!/bin/bash
mkdir home/vim/bundle.merged;
rm -r home/vim/bundle.merged/*
cd home/vim/bundle
for d in *;do
  cd $d
  cp -i -r * ../../bundle.merged
# Cp is better. I will move my vim files to a ramdisk
#  for f in **/*;do
#    t="$HOME/.vim/bundle.merged/$(dirname "$f")";
#    test -d "$t" || mkdir -p "$t";
#    ln "$f" "$t";
#  done;
  cd ..;
done

# Generate doc/tags file
vim -c ':helptags ../bundle.merged/doc/' -c ':q'
