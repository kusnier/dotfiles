function f () {
  #find . -not -name \*.svn-base -iname "$@"
  tput setaf 9
  echo "  find is busted"
  echo "  use ls with zsh globbing!!!"
  echo "  $ ls **/filename*"
}

