function f () {
  find . -not -name '*.svn-base' -iname $@
}
