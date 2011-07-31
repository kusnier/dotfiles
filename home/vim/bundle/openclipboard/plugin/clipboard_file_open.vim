function! OpenFilesFromClipboard()
  let clipboard = @*
  if clipboard =~ '^\s*$'
    let clipboard = @+
  endif

  let lines = split(clipboard, "\n")
  for line in lines
      let ifile      = split(line, ' ')[0]
      let file_line = 0

      if ifile =~ ':'
        let file_parts = split(ifile, ':')
        let ifile = file_parts[0]

        if file_parts[1] =~ '^\d+$/'
          let file_line = file_parts[1]
        endif
      endif

      execute 'tabnew ' . ifile

      if file_line
        call feedkeys(file_line . 'G')
      endif
  endfor

endfunction
