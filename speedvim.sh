#!/bin/bash
cd ~/.vim/bundle
mkdir ~/.vim/bundle.merged;
rm -r ~/.vim/bundle.merged/*
for d in *;do
  cd $d
  cp -i -r * ~/.vim/bundle.merged
# Cp is better. I will move my vim files to a ramdisk
#  for f in **/*;do
#    t="$HOME/.vim/bundle.merged/$(dirname "$f")";
#    test -d "$t" || mkdir -p "$t";
#    ln "$f" "$t";
#  done;
  cd ..;
done

# Generate doc/tags file
vim -c ':helptags ~/.vim/bundle.merged/doc/' -c ':q'
