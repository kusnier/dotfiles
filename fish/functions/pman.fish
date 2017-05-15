function pman -d "Pretty man pages" --wraps "man"
    man $argv -t | open -f -a Preview
end
