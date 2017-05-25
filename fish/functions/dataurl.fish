function dataurl --description 'Create a data URL from an image (works for other file types too, if you tweak the Content-Type afterwards)'
	set filename $argv[1]
    set extension (echo $filename | sed 's/^.*\.//')
    set base64 (openssl base64 -in "$filename")

    echo "data:image/$extension;base64,$base64" | tr -d '\n'
end
