function encrypt -d "Quick and dirty encryption" --wraps "openssl"
    openssl des3 -a -in $argv[1] -out $argv[1].des3
end
