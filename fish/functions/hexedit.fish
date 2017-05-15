function hexedit -d "Hex Editor" --wraps "xxd"
    xxd $argv[1] | vipe | xxd -r | sponge $argv[1]
end
