function runsub
    # Überprüfen, ob ein Kommando übergeben wurde
    if not set -q argv[1]
        echo "Usage: runsub <command> [args...]"
        return 1
    end

    # Iteriere durch alle Unterordner
    for dir in (find . -mindepth 1 -maxdepth 1 -type d)
        echo "Executing in $dir:"
        pushd $dir > /dev/null
        command $argv
        popd > /dev/null
        echo
    end
end
