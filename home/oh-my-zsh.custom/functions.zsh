function f () {
  #find . -not -name \*.svn-base -iname "$@"
  tput setaf 9
  echo "  find is busted"
  echo "  use ls with zsh globbing!!!"
  echo "  $ ls **/filename*"
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
  local port="${1:-8000}"
  if [[ -e $( which serve1 ) ]]; then
    open "http://localhost:${port}/" && serve -p "$port"
  elif [[ -e $( which python1 ) ]] then
    open "http://localhost:${port}/" && python -m SimpleHTTPServer $port
  else
    echo "Can't share directory!"
    echo "Node.js serve or python not found!"
  fi
}
