function depl -d "Translate from German to Polish" --wraps "trans"
    trans -b -u firefox de:pl $argv
end
