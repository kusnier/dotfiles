
" *******************************************************************************************************************
" DBI Result ********************************************************************************************************
" *******************************************************************************************************************

syn match DbiResultTableHead "^.*\t.*\t$" nextgroup=DbiResultTableDivide skipnl
syn match DbiResultTableDivide "^-[-\t]*$" nextgroup=DbiResultTableBody skipnl
syn match DbiResultTableBody "^[^-].*\t.*[^-]\t$" nextgroup=DbiResultTableBody,DbiResultTableEnd contains=DbiResultNull,DbiResultBool,DbiResultNumber,DbiResultStorageClass oneline
syn match DbiResultTableEnd "^(\d* rows)$" oneline 
syn match DbiResultNull "NULL" contained
syn match DbiResultBool " YES " contained
syn match DbiResultBool " NO " contained
syn match DbiResultStorageClass " PRI " contained
syn match DbiResultStorageClass " MUL " contained
syn match DbiResultStorageClass " UNI " contained
syn match DbiResultStorageClass "INT " contained
syn match DbiResultStorageClass "VARCHAR " contained
syn match DbiResultStorageClass "DATETIME " contained
syn match DbiResultStorageClass " CURRENT_TIMESTAMP " contained
syn match DbiResultStorageClass " auto_increment " contained
syn match DbiResultNumber "\d\+" contained
syn case match
syn region DbiResultString start=+'+ end=+'+ skip=+\\'+ contained oneline
syn region DbiResultString start=+"+ end=+"+ skip=+\\"+ contained oneline
syn region DbiResultString start=+`+ end=+`+ skip=+\\`+ contained oneline

hi def link DbiResultTableHead Title
hi def link DbiResultTableBody Normal
hi def link DbiResultBool Boolean
hi def link DbiResultStorageClass StorageClass
hi def link DbiResultNumber Number
hi def link DbiResultKeyword Keyword
hi def link DbiResultString String

" terms which have no reasonable default highlight group to link to
hi DbiResultTableHead term=bold cterm=bold gui=bold
if &background == 'dark'
    hi DbiResultTableEnd term=NONE cterm=NONE gui=NONE ctermfg=238 guifg=#444444
    hi DbiResultTableDivide term=NONE cterm=NONE gui=NONE ctermfg=238 guifg=#444444
    hi DbiResultTableStart term=NONE cterm=NONE gui=NONE ctermfg=238 guifg=#444444
    hi DbiResultNull term=NONE cterm=NONE gui=NONE ctermfg=238 guifg=#444444
elseif &background == 'light'
    hi DbiResultTableEnd term=NONE cterm=NONE gui=NONE ctermfg=247 guifg=#9e9e9e
    hi DbiResultTableDivide term=NONE cterm=NONE gui=NONE ctermfg=247 guifg=#9e9e9e
    hi DbiResultTableStart term=NONE cterm=NONE gui=NONE ctermfg=247 guifg=#9e9e9e
    hi DbiResultNull term=NONE cterm=NONE gui=NONE ctermfg=247 guifg=#9e9e9e
endif

" vim: foldmethod=marker
