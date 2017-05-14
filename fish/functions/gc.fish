function gc -d "gc" --wraps "git"
    git commit -v $argv
end
