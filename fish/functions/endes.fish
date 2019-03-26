function endes -d "Translate from English to German" --wraps "trans"
    trans -b -u firefox en:de $argv
end
