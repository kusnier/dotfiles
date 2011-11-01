source ~/.vim/bundle/phpDocumentor/php-doc.vim

inoremap <C-d> <esc>:call PhpDocSingle()<CR>
nnoremap <C-d> :call PhpDocSingle()<CR>
vnoremap <C-d> :call PhpDocRange()<CR>
