function fcowlol -d "Show a fun twitch banner" --wraps "figlet"
    figlet -f smslant -w9999 $argv | cowsay -W 9999 -n -p | lolcat
end
