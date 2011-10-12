" Create ctags for given path file
" Author:  Sebastian Kusnier
" Date: 11-Oct-2011
" Version: 0.4

if exists ("loaded_xptags")
    finish
endif
let loaded_xptags = 1

if !exists('g:global_xptags')
  let g:global_xptags = '~/devel/xp.public'
endif

function s:LoadPathfile(pathfile)
  if filereadable(a:pathfile)
    call delete("tags")
    call writefile([], "tags", "b")
    for line in readfile(a:pathfile)
      echo "UpdateTags: " . line
      call xolox#easytags#update(0, 0, ['-R', line])
    endfor
    echo "UpdateTags Global " . g:global_xptags
      call xolox#easytags#update(0, 0, ['-R', g:global_xptags])
    echo "Update xptags done."
  endif
endfunction

command! -complete=file -nargs=1 Xptags call s:LoadPathfile(<f-args>)