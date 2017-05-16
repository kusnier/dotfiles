function glog -d "Show git log in vim" --wraps "git"
    git log -p | vim - -g -R -c 'set foldmethod=syntax'
end
