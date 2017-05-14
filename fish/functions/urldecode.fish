function urldecode -d "Urldecode the input into plaintext output"
    python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])" $argv
end
