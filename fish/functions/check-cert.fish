function check-cert
	set hostToCheck $argv[1]
    echo | openssl s_client -showcerts -servername $hostToCheck -connect $hostToCheck:443 2>/dev/null | openssl x509 -inform pem -noout -text
end
