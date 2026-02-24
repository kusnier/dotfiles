function fish_user_key_bindings
    set -l dir "$HOME/.local/fish/scripts"
    set -l file "$dir/key-bindings.fish"
    set -l url "https://raw.githubusercontent.com/junegunn/fzf/refs/heads/master/shell/key-bindings.fish"

    # Ordner sicherstellen
    if not test -d $dir
        mkdir -p $dir
    end

    # Datei bei Bedarf laden
    if not test -f $file
        if type -q curl
            curl -fsSL $url -o $file
        else if type -q wget
            wget -q $url -O $file
        else
            echo "fzf: curl/wget fehlt – key-bindings.fish kann nicht geladen werden"
            return
        end
    end

    # Laden + aktivieren
    if test -f $file
        source $file
        if functions -q fzf_key_bindings
            fzf_key_bindings
        end
    end
end
