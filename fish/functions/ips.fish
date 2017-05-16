function ips -d "Ips" --wraps "ifconfig"
    ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'
end
