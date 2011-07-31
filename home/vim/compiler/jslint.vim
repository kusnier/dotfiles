" Vim compiler file
" Compiler:	jslint
" Maintainer:	Sebastian Kusnier <seek@matrixcode.de>
" URL:		http://matrixcode.de/jslint.vim
" Last Change:	2011 Jul 19
" Own Revision: $Id:$

if exists("current_compiler")
  finish
endif
let current_compiler = "jslint"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet makeprg=jslint\ %

CompilerSet errorformat=%-P%f,
                       \%-G/*jslint\ %.%#*/,
                       \%*[\ ]%n\ %l\\,%c:\ %m,
                       \%-G\ \ \ \ %.%#,
                       \%-GNo\ errors\ found.,
                       \%-Q

let &cpo = s:cpo_save
unlet s:cpo_save
