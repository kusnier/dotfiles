" CamelCaseComplete.vim: Insert mode completion that expands CamelCaseWords and
" underscore_words based on anchor characters for each word fragment. 
"
" DEPENDENCIES:
"   - Requires Vim 7.1 or higher. 
"   - CamelCaseComplete.vim autoload script. 
"
" Copyright: (C) 2009-2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"   1.00.014	18-Jan-2012	ENH: Add
"				g:CamelCaseComplete_CaseInsensitiveFallback:
"				When the completion base is all-lowercase, try
"				strict-noic -> strict-ic -> relaxed-noic ->
"				relaxed-ic fallback. 
"	013	11-Dec-2011	Split off functions into separate autoload
"				script and documentation into dedicated help
"				file. 
"	001	08-Jun-2009	file creation

" Avoid installing twice or when in unsupported Vim version. 
if exists('g:loaded_CamelCaseComplete') || (v:version < 701)
    finish
endif
let g:loaded_CamelCaseComplete = 1

"- configuration ---------------------------------------------------------------

if ! exists('g:CamelCaseComplete_complete')
    let g:CamelCaseComplete_complete = '.,w'
endif
if ! exists('g:CamelCaseComplete_FindStartMark')
    " To avoid clobbering user-set marks, we use the obscure "last exit point of
    " buffer" mark. 
    " Setting of mark '" is only supported since Vim 7.2; use last jump mark ''
    " for Vim 7.1. 
    let g:CamelCaseComplete_FindStartMark = (v:version < 702 ? "'" : '"')
endif
if ! exists('g:CamelCaseComplete_CaseInsensitiveFallback')
    let g:CamelCaseComplete_CaseInsensitiveFallback = 1
endif



"- mappings --------------------------------------------------------------------

inoremap <silent> <script> <Plug>(CamelCasePostComplete) <C-r>=CamelCaseComplete#RemoveBaseKeys()<CR>
inoremap <script> <expr> <Plug>(CamelCaseComplete) CamelCaseComplete#Expr()
if ! hasmapto('<Plug>(CamelCaseComplete)', 'i')
    if empty(maparg("\<C-c>", 'i'))
	" The i_CTRL-C command quits insert mode; it seems this even happens
	" when <C-c> is part of a mapping. To avoid this, the <C-c> command is
	" turned off here (unless it has already been remapped elsewhere). 
	inoremap <C-c> <Nop>
    endif
    execute 'imap <C-x><C-c> <Plug>(CamelCaseComplete)' . (empty(g:CamelCaseComplete_FindStartMark) ? '' : '<Plug>(CamelCasePostComplete)')
endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
