#!/bin/bash
git submodule foreach git checkout master
git submodule foreach git pull origin master

# omg. why a development branch and a empty master?
cd home/vim/bundle/vim-powerline/
git checkout develop
git pull origin develop
