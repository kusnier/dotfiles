" say.vim - Speaking text with say (macos)
"
" Maintainer:   Sebastian Kusnier <http://matrixcode.de>
" Version:      1.0

function! Say() range
  let str = ''
  if a:firstline != a:lastline
    for n in range(a:firstline, a:lastline)
      let str .= getline(n) . "\n"
    endfor
    call system('say &', str)
  endif
endfunction

command! -nargs=0 -range Say <line1>,<line2>call Say()

