# kusnier's dot files
My private dot files

## Install: step by step

1. cd`
2. git clone --recurse-submodules git://github.com/kusnier/dotfiles.git`
3. ~/dotfiles/update_symlinks.sh`

## Install: one liner
``bash
cd && git clone --recurse-submodules git://github.com/kusnier/dotfiles.git && ~/dotfiles/update_symlinks.sh
``

## Update
``bash
cd ~/dotfiles && git pull --recurse-submodules && ./update_symlinks.sh
``
