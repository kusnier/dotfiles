" Vim compiler file
" Compiler:	jshint
" Maintainer:	Sebastian Kusnier <seek@matrixcode.de>
" URL:		http://matrixcode.de/jshint.vim
" Last Change:	2011 Jul 19
" Own Revision: $Id:$

if exists("current_compiler")
  finish
endif
let current_compiler = "jshint"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet makeprg=jshint\ %

CompilerSet errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#

let &cpo = s:cpo_save
unlet s:cpo_save
