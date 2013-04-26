"==============================================================================
"  Description: svn line history
"               by Dmitry Ignatovich
"==============================================================================

let s:error_occured = "####"

function! s:GuaranteedExecute(shellcmd)
    let command_output = system(a:shellcmd)
    if (v:shell_error)
        let s:error_occured = l:command_output
        return 1
    endif
    return l:command_output
endfunction

function! s:SvnWorkingCopyIsModified(filename)
    let shellcmd = 'svn diff ' . a:filename
    let diff_output = s:GuaranteedExecute(shellcmd)
    return len(diff_output)
endfunction

function! s:SvnGetBackupFileName(filename)
    return a:filename . '.working.modified.backup'
endfunction

function! s:SvnGetCorrespondentLinenoInRepoFile(filename, lineno, line_text, working_copy_lines)
    let shellcmd = printf("cp %s %s", a:filename, s:SvnGetBackupFileName(a:filename))
    call s:GuaranteedExecute(shellcmd)
    if (s:error_occured != "####")
        return
    endif
    let shellcmd = 'svn revert ' . a:filename
    call s:GuaranteedExecute(shellcmd)
    if (s:error_occured != "####")
        return
    endif
    let wc_line_text_duplicates_count = count(a:working_copy_lines, a:line_text)
    let wc_line_duplicate_id = wc_line_text_duplicates_count == 1 ? 1 : count(a:working_copy_lines[0:a:lineno], a:line_text)
    let repo_lines = readfile(a:filename)
    let repo_line_text_duplicates_count = count(repo_lines, a:line_text)
    if (repo_line_text_duplicates_count != wc_line_text_duplicates_count)
        let s:error_occured = "cannot guess line to show history. Similiar line to requested was changed (added, modified or deleted) in working copy"
        return 1
    endif
    let repo_line_duplicate_id = 0
    let repo_lineno = 0
    while (repo_line_duplicate_id < wc_line_duplicate_id)
        let repo_lineno = index(repo_lines, a:line_text, repo_lineno) + 1 
        let repo_line_duplicate_id += 1
    endwhile
    return repo_lineno
endfunction

function! svn_line_history#show()
    let s:error_occured = "####"

    if (&modified)
        echohl WarningMsg | echo "cannot show line history: file has unsaved modifications. Exiting." | echohl None
        return
    endif

    let filename = expand("%:p")
    let lineno = line(".")

    let is_modified = s:SvnWorkingCopyIsModified(l:filename)
    if (s:error_occured != "####")
        echohl WarningMsg | echo s:error_occured | echohl None
        return
    endif

    let shellcmd = 'svn info --xml '
    let info_output = s:GuaranteedExecute(shellcmd)
    if (s:error_occured != "####")
        echohl WarningMsg | echo 'Error. ' . s:error_occured | echohl None
        return
    endif
    let info_lines = split(info_output, '\n')
    let root_ind = match(info_lines, '<root>.*</root>')
    if (root_ind == -1)
        echohl WarningMsg | echo 'Error. <root> section was not found in "svn info --xml"' | echohl None
        return
    endif
    let root_url = substitute(info_lines[root_ind], '<root>', '', '')
    let root_url = substitute(root_url, '</root>', '', '')

    let working_copy_lines = readfile(l:filename)
    let line_text = working_copy_lines[l:lineno - 1]
    let blame_lineno = l:lineno
    if (is_modified)
        try
            let blame_lineno = s:SvnGetCorrespondentLinenoInRepoFile(filename, lineno, line_text, working_copy_lines)
        finally
            if filereadable(s:SvnGetBackupFileName(l:filename))
                let shellcmd = printf("mv %s %s", s:SvnGetBackupFileName(l:filename), l:filename)
                call system(shellcmd)
                edit
            endif
        endtry
    endif
    if (s:error_occured != "####")
        echohl WarningMsg | echo 'Error. ' . s:error_occured | echohl None
        return
    endif
    
    let old_cmdheight = &cmdheight
    set cmdheight=2
    echo 'Sending requests to svn server. Please wait...'
    let &cmdheight=old_cmdheight

    let shellcmd = 'svn blame ' . filename
    let blame_output = s:GuaranteedExecute(shellcmd)
    if (s:error_occured != "####")
        echohl WarningMsg | echo 'Error. ' . s:error_occured | echohl None
        return
    endif
    let blame_line = split(blame_output, '\n')[blame_lineno - 1]
    let line_revision = split(blame_line, ' ')[0]

    let shellcmd = printf("svn log %s -r %s", root_url, line_revision)
    let log_output = s:GuaranteedExecute(shellcmd)
    if (s:error_occured != "####")
        echohl WarningMsg | echo 'Error. ' . s:error_occured | echohl None
        return
    endif

    let shellcmd = printf("svn diff %s -r %d:%d", root_url, line_revision - 1, line_revision)
    let diff_output = s:GuaranteedExecute(shellcmd)
    if (s:error_occured != "####")
        echohl WarningMsg | echo 'Error. ' . s:error_occured | echohl None
        return
    endif
    let report = printf("%s\n\n\n%s", log_output, diff_output)

    vnew
    set buftype=nofile
    set bufhidden=hide
    setlocal noswapfile
    call append(0, split(report, '\n'))
    call cursor(1, 1)
    set ft=diff
endfunction
