function decrypt -d "Quick and dirty encryption" --wraps "openssl"
    set targetfile (string replace '.des3' '' $argv[1])
    openssl des3 -d -a -in $argv[1] -out $targetfile
end
