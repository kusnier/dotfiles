fish_vi_key_bindings

# Useful functions {{{
# TODO: install and test nvim

#function ef; nvim ~/.config/fish/config.fish; end
#function eff; nvim ~/.config/fish/functions; end
#function eg; nvim ~/.gitconfig; end
#function ev; nvim ~/.vimrc; end

function ef; vim ~/.config/fish/config.fish; end
function eff; vim ~/.config/fish/functions; end
function eg; vim ~/.gitconfig; end
function ev; vim ~/.vimrc; end

function ..;    cd ..; end
function ...;   cd ../..; end
function ....;  cd ../../..; end
function .....; cd ../../../..; end
abbr -a -- -- 'cd -'
abbr -a -- -- 'cd -'
abbr -a ..g 'set cdto (git rev-parse --show-cdup); and git rev-parse; and cd "$cdto"'

# I give up
alias :q exit
alias :qa exit

# }}}
# Completions {{{

function make_completion --argument alias command
    complete -c $alias -xa "(
        set -l cmd (commandline -pc | sed -e 's/^ *\S\+ *//' );
        complete -C\"$command \$cmd\";
    )"
end

make_completion g "git"

# }}}
# Bind Keys {{{

# }}}
# Environment variables {{{


function prepend_to_path -d "Prepend the given dir to PATH if it exists and is not already in it"
    if test -d $argv[1]
        if not contains $argv[1] $PATH
            set -gx PATH "$argv[1]" $PATH
        end
    end
end
set -gx PATH "/sbin"
prepend_to_path "/usr/sbin"
prepend_to_path "/bin"
prepend_to_path "/usr/bin"
prepend_to_path "/usr/local/bin"
prepend_to_path "/usr/local/sbin"
prepend_to_path "/usr/local/share/npm/bin"
prepend_to_path "$HOME/bin"

set BROWSER open

#set -g -x fish_greeting ''
#set -g -x EDITOR nvim
set -g -x EDITOR vim
set -g -x COMMAND_MODE unix2003
set -g -x NODE_PATH "/usr/local/lib/node_modules"

set -g -x VIM_BINARY "/usr/local/bin/vim"
set -g -x MVIM_BINARY "/usr/local/bin/mvim"

set -g -x MAVEN_OPTS "-Xmx512M -XX:MaxPermSize=512M"
set -g -x _JAVA_OPTIONS "-Djava.awt.headless=true"

function headed_java -d "Put Java into headed mode"
    echo "Changing _JAVA_OPTIONS"
    echo "from: $_JAVA_OPTIONS"
    set -g -e _JAVA_OPTIONS
    echo "  to: $_JAVA_OPTIONS"
end
function headless_java -d "Put Java into headless mode"
    echo "Changing _JAVA_OPTIONS"
    echo "from: $_JAVA_OPTIONS"
    set -g -x _JAVA_OPTIONS "-Djava.awt.headless=true"
    echo "  to: $_JAVA_OPTIONS"
end


# }}}

# Prompt {{{

# }}}

if test -f $HOME/.local.fish
    . $HOME/.local.fish
end

true
