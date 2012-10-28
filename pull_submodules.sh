#!/bin/bash
git pull origin master
git submodule update --init
git submodule foreach git submodule update --init
git submodule foreach git pull

# omg. why a development branch and a empty master?
git submodule foreach '[ "$path" = "home/vim/bundle/vim-powerline" ] && branch=develop || branch=master; git checkout $branch'
