function path_this -d "Add the cwd to the front of PATH"
    set PATH (pwd) $PATH
end
