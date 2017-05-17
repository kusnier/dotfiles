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

set _home $HOME
set -gx PATH "$_home/bin" $PATH

if test ! -f /usr/local/bin/fzf
    set -gx PATH "$_home/.fzf/bin" $PATH
end

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

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish


# Colors:
set fish_color_normal F8F8F2 # the default color
set fish_color_command F92672 # the color for commands
set fish_color_quote E6DB74 # the color for quoted blocks of text
set fish_color_redirection AE81FF # the color for IO redirections
set fish_color_end F8F8F2 # the color for process separators like ';' and '&'
set fish_color_error F8F8F2 --background=F92672 # the color used to highlight potential errors
set fish_color_param A6E22E # the color for regular command parameters
set fish_color_comment 75715E # the color used for code comments
set fish_color_match F8F8F2 # the color used to highlight matching parenthesis
set fish_color_search_match --background=49483E # the color used to highlight history search matches
set fish_color_operator AE81FF # the color for parameter expansion operators like '*' and '~'
set fish_color_escape 66D9EF # the color used to highlight character escapes like '\n' and '\x70'
set fish_color_cwd 66D9EF # the color used for the current working directory in the default prompt

# Additionally, the following variables are available to change the highlighting in the completion pager:
set fish_pager_color_prefix F8F8F2 # the color of the prefix string, i.e. the string that is to be completed
set fish_pager_color_completion 75715E # the color of the completion itself
set fish_pager_color_description 49483E # the color of the completion description
set fish_pager_color_progress F8F8F2 # the color of the progress bar at the bottom left corner
set fish_pager_color_secondary F8F8F2 # the background color of the every second completion
