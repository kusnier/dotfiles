function dataurl -d "Create data url from image"
	set filename $argv[1]
    set extension (echo $filename | sed 's/^.*\.//')
    set base64 (openssl base64 -in "$filename")

    echo "data:image/$extension;base64,$base64" | tr -d '\n'
end
