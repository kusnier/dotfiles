function deen -d "Translate from German to English" --wraps "trans"
    trans -b -u firefox de:en $argv
end
