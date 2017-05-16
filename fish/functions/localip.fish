function localip -d "Local ip" --wraps "ipconfig"
    ipconfig getifaddr en0
end
