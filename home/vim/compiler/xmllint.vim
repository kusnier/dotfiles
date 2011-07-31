" Vim compiler file
" Compiler:	xmllint
" Maintainer:	Doug Kearns <djkea2@gus.gscit.monash.edu.au>
" URL:		http://gus.gscit.monash.edu.au/~djkea2/vim/compiler/xmllint.vim
" Last Change:	2004 Nov 27
" Own Revision: $Id:$
" Own Changes: Errorformat updated. space between : added
" Own Changes: Ignore 'no DTD found' message

if exists("current_compiler")
  finish
endif
let current_compiler = "xmllint"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet makeprg=xmllint\ --valid\ --noout\ %

CompilerSet errorformat=%E%f:%l:\ error\ :\ %m,
		    \%-G%f:%l:\ validity\ error\ :\ Validation\ failed:\ no\ DTD\ found\ %m,
		    \%W%f:%l:\ warning\ :\ %m,
		    \%W%f:%l:\ validity\ warning\ :\ %m,
		    \%E%f:%l:\ validity\ error\ :\ %m,
		    \%E%f:%l:\ parser\ error\ :\ %m,
		    \%E%f:%l:\ namespace\ error\ :\ %m,
		    \%E%f:%l:\ %m,
		    \%-Z%p^,
		    \%-G%.%#

let &cpo = s:cpo_save
unlet s:cpo_save
