function quietly -d "Run a command and hide the output"
    eval $argv >/dev/null ^/dev/null
end
