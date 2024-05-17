# Install brew
# https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Run after installation
# (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> $HOME/.config/fish/config.fish
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"