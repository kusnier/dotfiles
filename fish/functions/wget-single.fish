function wget-single -d "wget a single page"
    wget --no-parent --timestamping --convert-links --page-requisites --no-directories --no-host-directories --span-hosts --adjust-extension $argv
end
