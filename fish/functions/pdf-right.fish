function pdf-right -d "Rotate pdf to right"
    pdftk $argv[1] cat 1-endeast output $argv[2]
end
