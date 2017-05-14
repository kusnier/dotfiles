function wget-site -d "wget an entire site"
    wget --mirror --convert-links --adjust-extension --page-requisites --no-parent --wait=1 $argv
end
