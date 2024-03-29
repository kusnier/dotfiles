# kusnier's dot files

My private dot files

## Install: step by step

1. `git clone --recurse-submodules git://github.com/kusnier/dotfiles.git`
2. `./dotfiles/update_symlinks.sh`

## Install: one liner

```bash
git clone --recurse-submodules git://github.com/kusnier/dotfiles.git && ./dotfiles/update_symlinks.sh
```

## Update

Go to dotfiles directory

```bash
git pull --recurse-submodules && ./update_symlinks.sh
```

## Vim settings

[Myvim][myvim]

## Speedup vim

With each new module in vim/bundle the startup becomes slower.

To speedup the startup i have created a script to copy all bundles in a merged folder (bundle.merged).

After this merge the merged version is copied to RAM (Linux: /dev/shm).

In vimrc i do

*   /dev/shm/vim.bundle.merged/ exists -> Add RAM version to runtime path
*   ~/.vim/bundle.merged/ exists -> Add merged version to runtime path
*   Otherwise use pathogen in the normal way

```bash
yes | ./speedvim.sh
```

[myvim]: https://raw.github.com/kusnier/dotfiles/master/home/vim/doc/myvim.txt
