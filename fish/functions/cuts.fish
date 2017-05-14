function cuts -d "Cut on space characters instead of tabs" --wraps "cut"
    cut -d' ' $argv
end
