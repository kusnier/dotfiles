function ql -d "Quick-look a file (^C to close)" --wraps "qlmanage"
    qlmanage -p 2>/dev/null $argv
end
