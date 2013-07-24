"===============================================================================
"
"          File:  bash-support.vim
" 
"   Description:  bash support
"
"                  Write bash scripts by inserting comments, statements,
"                  variables and builtins.
" 
"   VIM Version:  7.0+
"        Author:  Dr. Fritz Mehner (fgm), mehner.fritz@fh-swf.de
"  Organization:  FH Südwestfalen, Iserlohn, Germany
"       Version:  see g:BASH_Version below
"       Created:  26.02.2001
"       License:  Copyright (c) 2001-2013, Dr. Fritz Mehner
"                 This program is free software; you can redistribute it and/or
"                 modify it under the terms of the GNU General Public License as
"                 published by the Free Software Foundation, version 2 of the
"                 License.
"                 This program is distributed in the hope that it will be
"                 useful, but WITHOUT ANY WARRANTY; without even the implied
"                 warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
"                 PURPOSE.
"                 See the GNU General Public License version 2 for more details.
"===============================================================================
"
if v:version < 700
  echohl WarningMsg | echo 'plugin bash-support.vim needs Vim version >= 7'| echohl None
  finish
endif
"
" Prevent duplicate loading:
"
if exists("g:BASH_Version") || &cp
 finish
endif
"
let g:BASH_Version= "4.0"                  " version number of this script; do not change
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_SetGlobalVariable     {{{1
"   DESCRIPTION:  Define a global variable and assign a default value if nor
"                 already defined
"    PARAMETERS:  name - global variable
"                 default - default value
"===============================================================================
function! s:BASH_SetGlobalVariable ( name, default )
  if !exists('g:'.a:name)
    exe 'let g:'.a:name."  = '".a:default."'"
	else
		" check for an empty initialization
		exe 'let	val	= g:'.a:name
		if empty(val)
			exe 'let g:'.a:name."  = '".a:default."'"
		endif
  endif
endfunction   " ---------- end of function  s:BASH_SetGlobalVariable  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  GetGlobalSetting     {{{1
"   DESCRIPTION:  take over a global setting
"    PARAMETERS:  varname - variable to set
"       RETURNS:  
"===============================================================================
function! s:GetGlobalSetting ( varname )
	if exists ( 'g:'.a:varname )
		exe 'let s:'.a:varname.' = g:'.a:varname
	endif
endfunction    " ----------  end of function s:GetGlobalSetting  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  ApplyDefaultSetting     {{{1
"   DESCRIPTION:  make a local setting global
"    PARAMETERS:  varname - variable to set
"       RETURNS:  
"===============================================================================
function! s:ApplyDefaultSetting ( varname )
	if ! exists ( 'g:'.a:varname )
		exe 'let g:'.a:varname.' = s:'.a:varname
	endif
endfunction    " ----------  end of function s:ApplyDefaultSetting  ----------
"
"------------------------------------------------------------------------------
" *** PLATFORM SPECIFIC ITEMS ***     {{{1
"------------------------------------------------------------------------------
let s:MSWIN = has("win16") || has("win32")   || has("win64") || has("win95")
let s:UNIX	= has("unix")  || has("macunix") || has("win32unix")
"
let s:installation						= '*undefined*'
let s:BASH_GlobalTemplateFile	= ''
let s:BASH_GlobalTemplateDir	= ''
let s:BASH_LocalTemplateFile	= ''
let s:BASH_LocalTemplateDir		= ''
let s:BASH_FilenameEscChar 		= ''
let s:BASH_XtermDefaults      = '-fa courier -fs 12 -geometry 80x24'


if	s:MSWIN
  " ==========  MS Windows  ======================================================
	"
	" change '\' to '/' to avoid interpretation as escape character
	if match(	substitute( expand("<sfile>"), '\', '/', 'g' ), 
				\		substitute( expand("$HOME"),   '\', '/', 'g' ) ) == 0
		"
		" USER INSTALLATION ASSUMED
		let s:installation						= 'local'
		let s:plugin_dir  						= substitute( expand('<sfile>:p:h:h'), '\', '/', 'g' )
		let s:BASH_LocalTemplateFile	= s:plugin_dir.'/bash-support/templates/Templates'
		let s:BASH_LocalTemplateDir		= fnamemodify( s:BASH_LocalTemplateFile, ":p:h" ).'/'
	else
		"
		" SYSTEM WIDE INSTALLATION
		let s:installation						= 'system'
		let s:plugin_dir						 	= $VIM.'/vimfiles'
		let s:BASH_GlobalTemplateDir	= s:plugin_dir.'/bash-support/templates'
		let s:BASH_GlobalTemplateFile	= s:BASH_GlobalTemplateDir.'/Templates'
		let s:BASH_LocalTemplateFile	= $HOME.'/vimfiles/bash-support/templates/Templates'
		let s:BASH_LocalTemplateDir		= fnamemodify( s:BASH_LocalTemplateFile, ":p:h" ).'/'
	endif
	"
  let s:BASH_FilenameEscChar 		= ''
	let s:BASH_Display    				= ''
	let s:BASH_ManualReader				= 'man.exe'
	let s:BASH_BASH								= 'bash.exe'
	let s:BASH_OutputGvim					= 'xterm'
	"
else
  " ==========  Linux/Unix  ======================================================
	"
	if match( expand("<sfile>"), resolve( expand("$HOME") ) ) == 0
		"
		" USER INSTALLATION ASSUMED
		let s:installation						= 'local'
		let s:plugin_dir 							= expand('<sfile>:p:h:h')
		let s:BASH_LocalTemplateFile	= s:plugin_dir.'/bash-support/templates/Templates'
		let s:BASH_LocalTemplateDir		= fnamemodify( s:BASH_LocalTemplateFile, ":p:h" ).'/'
	else
		"
		" SYSTEM WIDE INSTALLATION
		let s:installation						= 'system'
		let s:plugin_dir							= $VIM.'/vimfiles'
		let s:BASH_GlobalTemplateDir	= s:plugin_dir.'/bash-support/templates'
		let s:BASH_GlobalTemplateFile	= s:BASH_GlobalTemplateDir.'/Templates'
		let s:BASH_LocalTemplateFile	= $HOME.'/.vim/bash-support/templates/Templates'
		let s:BASH_LocalTemplateDir		= fnamemodify( s:BASH_LocalTemplateFile, ":p:h" ).'/'
	endif
	"
	let s:BASH_BASH								= $SHELL
  let s:BASH_FilenameEscChar 		= ' \%#[]'
	let s:BASH_Display						= $DISPLAY
	let s:BASH_ManualReader				= '/usr/bin/man'
	let s:BASH_OutputGvim					= 'vim'
	"
endif
"
let s:BASH_CodeSnippets  				= s:plugin_dir.'/bash-support/codesnippets/'
call s:BASH_SetGlobalVariable( 'BASH_CodeSnippets', s:BASH_CodeSnippets )
"
"
"  g:BASH_Dictionary_File  must be global
"
if !exists("g:BASH_Dictionary_File")
	let g:BASH_Dictionary_File     = s:plugin_dir.'/bash-support/wordlists/bash-keywords.list'
endif
"
"----------------------------------------------------------------------
"  *** MODUL GLOBAL VARIABLES *** {{{1
"----------------------------------------------------------------------
"
let s:BASH_CreateMenusDelayed	= 'yes'
let s:BASH_MenuVisible				= 'no'
let s:BASH_GuiSnippetBrowser 	= 'gui'             " gui / commandline
let s:BASH_LoadMenus         	= 'yes'             " load the menus?
let s:BASH_RootMenu          	= '&Bash'           " name of the root menu
let s:BASH_Debugger           = 'term'
let s:BASH_bashdb             = 'bashdb'
"
let s:BASH_MapLeader             	= ''            " default: do not overwrite 'maplocalleader'
let s:BASH_LineEndCommColDefault	= 49
let s:BASH_Printheader   					= "%<%f%h%m%<  %=%{strftime('%x %X')}     Page %N"
let s:BASH_TemplateJumpTarget 		= ''
let s:BASH_Errorformat    				= '%f:\ %s\ %l:\ %m'
let s:BASH_Wrapper               	= s:plugin_dir.'/bash-support/scripts/wrapper.sh'
let s:BASH_InsertFileHeader				= 'yes'
let s:BASH_SyntaxCheckOptionsGlob = ''

"
call s:GetGlobalSetting ( 'BASH_Debugger' )
call s:GetGlobalSetting ( 'BASH_bashdb' )
call s:GetGlobalSetting ( 'BASH_SyntaxCheckOptionsGlob' )
call s:GetGlobalSetting ( 'BASH_InsertFileHeader' )
call s:GetGlobalSetting ( 'BASH_GuiSnippetBrowser' )
call s:GetGlobalSetting ( 'BASH_LoadMenus' )
call s:GetGlobalSetting ( 'BASH_RootMenu' )
call s:GetGlobalSetting ( 'BASH_Printheader' )
call s:GetGlobalSetting ( 'BASH_ManualReader' )
call s:GetGlobalSetting ( 'BASH_OutputGvim' )
call s:GetGlobalSetting ( 'BASH_XtermDefaults' )
call s:GetGlobalSetting ( 'BASH_LocalTemplateFile' )
call s:GetGlobalSetting ( 'BASH_GlobalTemplateFile' )
call s:GetGlobalSetting ( 'BASH_CreateMenusDelayed' )
call s:GetGlobalSetting ( 'BASH_LineEndCommColDefault' )

call s:ApplyDefaultSetting ( 'BASH_MapLeader'    )
"
" set default geometry if not specified
"
if match( s:BASH_XtermDefaults, "-geometry\\s\\+\\d\\+x\\d\\+" ) < 0
	let s:BASH_XtermDefaults	= s:BASH_XtermDefaults." -geometry 80x24"
endif
"
let s:BASH_Printheader  					= escape( s:BASH_Printheader, ' %' )
let s:BASH_saved_global_option		= {}
let b:BASH_BashCmdLineArgs				= ''
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_SaveGlobalOption     {{{1
"   DESCRIPTION:  
"    PARAMETERS:  option name
"                 characters to be escaped (optional)
"       RETURNS:  
"===============================================================================
function! s:BASH_SaveGlobalOption ( option, ... )
	exe 'let escaped =&'.a:option
	if a:0 == 0
		let escaped	= escape( escaped, ' |"\' )
	else
		let escaped	= escape( escaped, ' |"\'.a:1 )
	endif
	let s:BASH_saved_global_option[a:option]	= escaped
endfunction    " ----------  end of function BASH_SaveGlobalOption  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_RestoreGlobalOption     {{{1
"   DESCRIPTION:  
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! s:BASH_RestoreGlobalOption ( option )
	exe ':set '.a:option.'='.s:BASH_saved_global_option[a:option]
endfunction    " ----------  end of function BASH_RestoreGlobalOption  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_Input     {{{1
"   DESCRIPTION:  Input after a highlighted prompt
"    PARAMETERS:  prompt       - prompt string
"                 defaultreply - default reply
"                 ...          - completion
"       RETURNS:  reply
"===============================================================================
function! BASH_Input ( prompt, defaultreply, ... )
	echohl Search																					" highlight prompt
	call inputsave()																			" preserve typeahead
	if a:0 == 0 || empty(a:1)
		let retval	=input( a:prompt, a:defaultreply )
	else
		let retval	=input( a:prompt, a:defaultreply, a:1 )
	endif
	call inputrestore()																		" restore typeahead
	echohl None																						" reset highlighting
	let retval  = substitute( retval, '^\s\+', '', '' )		" remove leading whitespaces
	let retval  = substitute( retval, '\s\+$', '', '' )		" remove trailing whitespaces
	return retval
endfunction    " ----------  end of function BASH_Input ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_AdjustLineEndComm     {{{1
"   DESCRIPTION:  adjust end-of-line comments
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_AdjustLineEndComm ( ) range
	"
	" patterns to ignore when adjusting line-end comments (maybe incomplete):
	let	s:AlignRegex	= [
				\	'\([^"]*"[^"]*"\)\+' ,
				\	]

	if !exists("b:BASH_LineEndCommentColumn")
		let	b:BASH_LineEndCommentColumn	= s:BASH_LineEndCommColDefault
	endif

	let save_cursor = getpos('.')

	let	save_expandtab	= &expandtab
	exe	':set expandtab'

	let	linenumber	= a:firstline
	exe ':'.a:firstline

	while linenumber <= a:lastline
		let	line= getline('.')

		let idx1	= 1 + match( line, '\s*#.*$', 0 )
		let idx2	= 1 + match( line,    '#.*$', 0 )

		" comment with leading whitespaces left unchanged
		if     match( line, '^\s*#' ) == 0
			let idx1	= 0
			let idx2	= 0
		endif

		for regex in s:AlignRegex
			if match( line, regex ) > -1
				let start	= matchend( line, regex )
				let idx1	= 1 + match( line, '\s*#.*$', start )
				let idx2	= 1 + match( line,    '#.*$', start )
				break
			endif
		endfor

		let	ln	= line('.')
		call setpos('.', [ 0, ln, idx1, 0 ] )
		let vpos1	= virtcol('.')
		call setpos('.', [ 0, ln, idx2, 0 ] )
		let vpos2	= virtcol('.')

		if   ! (   vpos2 == b:BASH_LineEndCommentColumn
					\	|| vpos1 > b:BASH_LineEndCommentColumn
					\	|| idx2  == 0 )

			exe ':.,.retab'
			" insert some spaces
			if vpos2 < b:BASH_LineEndCommentColumn
				let	diff	= b:BASH_LineEndCommentColumn-vpos2
				call setpos('.', [ 0, ln, vpos2, 0 ] )
				let	@"	= ' '
				exe 'normal	'.diff.'P'
			end

			" remove some spaces
			if vpos1 < b:BASH_LineEndCommentColumn && vpos2 > b:BASH_LineEndCommentColumn
				let	diff	= vpos2 - b:BASH_LineEndCommentColumn
				call setpos('.', [ 0, ln, b:BASH_LineEndCommentColumn, 0 ] )
				exe 'normal	'.diff.'x'
			end

		end
		let linenumber=linenumber+1
		normal j
	endwhile
	" restore tab expansion settings and cursor position
	let &expandtab	= save_expandtab
	call setpos('.', save_cursor)

endfunction		" ---------- end of function  BASH_AdjustLineEndComm  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_GetLineEndCommCol     {{{1
"   DESCRIPTION:  get end-of-line comment position
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_GetLineEndCommCol ()
	let actcol	= virtcol(".")
	if actcol+1 == virtcol("$")
		let	b:BASH_LineEndCommentColumn	= ''
		while match( b:BASH_LineEndCommentColumn, '^\s*\d\+\s*$' ) < 0
			let b:BASH_LineEndCommentColumn = BASH_Input( 'start line-end comment at virtual column : ', actcol, '' )
		endwhile
	else
		let	b:BASH_LineEndCommentColumn	= virtcol(".")
	endif
  echomsg "line end comments will start at column  ".b:BASH_LineEndCommentColumn
endfunction		" ---------- end of function  BASH_GetLineEndCommCol  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_EndOfLineComment     {{{1
"   DESCRIPTION:  single end-of-line comment
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_EndOfLineComment ( ) range
	if !exists("b:BASH_LineEndCommentColumn")
		let	b:BASH_LineEndCommentColumn	= s:BASH_LineEndCommColDefault
	endif
	" ----- trim whitespaces -----
	exe a:firstline.','.a:lastline.'s/\s*$//'

	for line in range( a:lastline, a:firstline, -1 )
		silent exe ":".line
		if getline(line) !~ '^\s*$'
			let linelength	= virtcol( [line, "$"] ) - 1
			let	diff				= 1
			if linelength < b:BASH_LineEndCommentColumn
				let diff	= b:BASH_LineEndCommentColumn -1 -linelength
			endif
			exe "normal	".diff."A "
			call mmtemplates#core#InsertTemplate(g:BASH_Templates, 'Comments.end-of-line comment')
		endif
	endfor
endfunction		" ---------- end of function  BASH_EndOfLineComment  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_CodeComment     {{{1
"   DESCRIPTION:  Code -> Comment
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_CodeComment() range
	" add '# ' at the beginning of the lines
	for line in range( a:firstline, a:lastline )
		exe line.'s/^/# /'
	endfor
endfunction    " ----------  end of function BASH_CodeComment  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_CommentCode     {{{1
"   DESCRIPTION:  Comment -> Code
"    PARAMETERS:  toggle - 0 : uncomment, 1 : toggle comment
"       RETURNS:  
"===============================================================================
function! BASH_CommentCode( toggle ) range
	for i in range( a:firstline, a:lastline )
		if getline( i ) =~ '^# '
			silent exe i.'s/^# //'
		elseif getline( i ) =~ '^#'
			silent exe i.'s/^#//'
		elseif a:toggle
			silent exe i.'s/^/# /'
		endif
	endfor
	"
endfunction    " ----------  end of function BASH_CommentCode  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_echo_comment     {{{1
"   DESCRIPTION:  put statement in an echo
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_echo_comment ()
	let	line	= escape( getline("."), '"' )
	let	line	= substitute( line, '^\s*', '', '' )
	call setline( line("."), 'echo "'.line.'"' )
	silent exe "normal =="
	return
endfunction    " ----------  end of function BASH_echo_comment  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_remove_echo     {{{1
"   DESCRIPTION:  remove echo from statement
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_remove_echo ()
	let	line	= substitute( getline("."), '\\"', '"', 'g' )
	let	line	= substitute( line, '^\s*echo\s\+"', '', '' )
	let	line	= substitute( line, '"$', '', '' )
	call setline( line("."), line )
	silent exe "normal =="
	return
endfunction    " ----------  end of function BASH_remove_echo  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_RereadTemplates     {{{1
"   DESCRIPTION:  Reread the templates. Also set the character which starts
"                 the comments in the template files.
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! g:BASH_RereadTemplates ( displaymsg )
	"
	"-------------------------------------------------------------------------------
	" SETUP TEMPLATE LIBRARY
	"-------------------------------------------------------------------------------
	let g:BASH_Templates = mmtemplates#core#NewLibrary ()
	"
	" mapleader
	if empty ( g:BASH_MapLeader )
		call mmtemplates#core#Resource ( g:BASH_Templates, 'set', 'property', 'Templates::Mapleader', '\' )
	else
		call mmtemplates#core#Resource ( g:BASH_Templates, 'set', 'property', 'Templates::Mapleader', g:BASH_MapLeader )
	endif
	"
	" map: choose style
	call mmtemplates#core#Resource ( g:BASH_Templates, 'set', 'property', 'Templates::EditTemplates::Map',   'ntl' )
	call mmtemplates#core#Resource ( g:BASH_Templates, 'set', 'property', 'Templates::RereadTemplates::Map', 'ntr' )
	call mmtemplates#core#Resource ( g:BASH_Templates, 'set', 'property', 'Templates::ChooseStyle::Map',     'nts' )
	"
	" syntax: comments
	call mmtemplates#core#ChangeSyntax ( g:BASH_Templates, 'comment', '§' )
	let s:BASH_TemplateJumpTarget = mmtemplates#core#Resource ( g:BASH_Templates, "jumptag" )[0]
	"
	let	messsage = ''
	"
	if s:installation == 'system'
		"-------------------------------------------------------------------------------
		" SYSTEM INSTALLATION
		"-------------------------------------------------------------------------------
		if filereadable( s:BASH_GlobalTemplateFile )
			call mmtemplates#core#ReadTemplates ( g:BASH_Templates, 'load', s:BASH_GlobalTemplateFile )
		else
			echomsg "Global template file '".s:BASH_GlobalTemplateFile."' not readable."
			return
		endif
		let	messsage	= "Templates read from '".s:BASH_GlobalTemplateFile."'"
		"
		"-------------------------------------------------------------------------------
		" handle local template files
		"-------------------------------------------------------------------------------
		if finddir( s:BASH_LocalTemplateDir ) == ''
			" try to create a local template directory
			if exists("*mkdir")
				try 
					call mkdir( s:BASH_LocalTemplateDir, "p" )
				catch /.*/
				endtry
			endif
		endif

		if isdirectory( s:BASH_LocalTemplateDir ) && !filereadable( s:BASH_LocalTemplateFile )
			" write a default local template file
			let template	= [	]
			let sample_template_file	= fnamemodify( s:BASH_GlobalTemplateDir, ':h' ).'/rc/sample_template_file'
			if filereadable( sample_template_file )
				for line in readfile( sample_template_file )
					call add( template, line )
				endfor
				call writefile( template, s:BASH_LocalTemplateFile )
			endif
		endif
		"
		if filereadable( s:BASH_LocalTemplateFile )
			call mmtemplates#core#ReadTemplates ( g:BASH_Templates, 'load', s:BASH_LocalTemplateFile )
			let messsage	= messsage." and '".s:BASH_LocalTemplateFile."'"
			if mmtemplates#core#ExpandText( g:BASH_Templates, '|AUTHOR|' ) == 'YOUR NAME'
				echomsg "Please set your personal details in file '".s:BASH_LocalTemplateFile."'."
			endif
		endif
		"
	else
		"-------------------------------------------------------------------------------
		" LOCAL INSTALLATION
		"-------------------------------------------------------------------------------
		if filereadable( s:BASH_LocalTemplateFile )
			call mmtemplates#core#ReadTemplates ( g:BASH_Templates, 'load', s:BASH_LocalTemplateFile )
			let	messsage	= "Templates read from '".s:BASH_LocalTemplateFile."'"
		else
			echomsg "Local template file '".s:BASH_LocalTemplateFile."' not readable." 
			return
		endif
		"
	endif
	if a:displaymsg == 'yes'
		echomsg messsage.'.'
	endif

endfunction    " ----------  end of function BASH_RereadTemplates  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  InitMenus     {{{1
"   DESCRIPTION:  Initialize menus.
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! s:InitMenus()
	"
	if ! has ( 'menu' )
		return
	endif
	"
 	"-------------------------------------------------------------------------------
	" preparation      {{{2
	"-------------------------------------------------------------------------------
	call mmtemplates#core#CreateMenus ( 'g:BASH_Templates', s:BASH_RootMenu, 'do_reset' )
	"
	" get the mapleader (correctly escaped)
	let [ esc_mapl, err ] = mmtemplates#core#Resource ( g:BASH_Templates, 'escaped_mapleader' )
	"
	exe 'amenu '.s:BASH_RootMenu.'.Bash  <Nop>'
	exe 'amenu '.s:BASH_RootMenu.'.-Sep00- <Nop>'
	"
 	"-------------------------------------------------------------------------------
	" menu headers     {{{2
	"-------------------------------------------------------------------------------
	"
	call mmtemplates#core#CreateMenus ( 'g:BASH_Templates', s:BASH_RootMenu, 'sub_menu', '&Comments', 'priority', 500 )
	" the other, automatically created menus go here; their priority is the standard priority 500
	call mmtemplates#core#CreateMenus ( 'g:BASH_Templates', s:BASH_RootMenu, 'sub_menu', 'S&nippets', 'priority', 600 )
	call mmtemplates#core#CreateMenus ( 'g:BASH_Templates', s:BASH_RootMenu, 'sub_menu', '&Run'     , 'priority', 700 )
	call mmtemplates#core#CreateMenus ( 'g:BASH_Templates', s:BASH_RootMenu, 'sub_menu', '&Help'    , 'priority', 800 )
	"
	"-------------------------------------------------------------------------------
	" comments     {{{2
 	"-------------------------------------------------------------------------------
	"
	let  head =  'noremenu <silent> '.s:BASH_RootMenu.'.Comments.'
	let ahead = 'anoremenu <silent> '.s:BASH_RootMenu.'.Comments.'
	let vhead = 'vnoremenu <silent> '.s:BASH_RootMenu.'.Comments.'
	let ihead = 'inoremenu <silent> '.s:BASH_RootMenu.'.Comments.'
	"
	exe ahead.'end-of-&line\ comment<Tab>'.esc_mapl.'cl                 :call BASH_EndOfLineComment()<CR>'
	exe vhead.'end-of-&line\ comment<Tab>'.esc_mapl.'cl                 :call BASH_EndOfLineComment()<CR>'

	exe ahead.'ad&just\ end-of-line\ com\.<Tab>'.esc_mapl.'cj           :call BASH_AdjustLineEndComm()<CR>'
	exe ihead.'ad&just\ end-of-line\ com\.<Tab>'.esc_mapl.'cj      <Esc>:call BASH_AdjustLineEndComm()<CR>'
	exe vhead.'ad&just\ end-of-line\ com\.<Tab>'.esc_mapl.'cj           :call BASH_AdjustLineEndComm()<CR>'
	exe  head.'&set\ end-of-line\ com\.\ col\.<Tab>'.esc_mapl.'cs  <Esc>:call BASH_GetLineEndCommCol()<CR>'
	"
	exe ahead.'-Sep01-						<Nop>'
	exe ahead.'&comment<TAB>'.esc_mapl.'cc															:call BASH_CodeComment()<CR>'
	exe vhead.'&comment<TAB>'.esc_mapl.'cc															:call BASH_CodeComment()<CR>'
	exe ahead.'&uncomment<TAB>'.esc_mapl.'cu														:call BASH_CommentCode(0)<CR>'
	exe vhead.'&uncomment<TAB>'.esc_mapl.'cu														:call BASH_CommentCode(0)<CR>'
	exe ahead.'-Sep02-						<Nop>'
	"
	"-------------------------------------------------------------------------------
	" generate menus from the templates
 	"-------------------------------------------------------------------------------
	"
	call mmtemplates#core#CreateMenus ( 'g:BASH_Templates', s:BASH_RootMenu, 'do_templates' )
	"
	"-------------------------------------------------------------------------------
	" snippets     {{{2
	"-------------------------------------------------------------------------------
	"
	if !empty(s:BASH_CodeSnippets)
		"
		exe "amenu  <silent> ".s:BASH_RootMenu.'.S&nippets.&read\ code\ snippet<Tab>'.esc_mapl.'nr       :call BASH_CodeSnippet("read")<CR>'
		exe "imenu  <silent> ".s:BASH_RootMenu.'.S&nippets.&read\ code\ snippet<Tab>'.esc_mapl.'nr  <C-C>:call BASH_CodeSnippet("read")<CR>'
		exe "amenu  <silent> ".s:BASH_RootMenu.'.S&nippets.&view\ code\ snippet<Tab>'.esc_mapl.'nv       :call BASH_CodeSnippet("view")<CR>'
		exe "imenu  <silent> ".s:BASH_RootMenu.'.S&nippets.&view\ code\ snippet<Tab>'.esc_mapl.'nv  <C-C>:call BASH_CodeSnippet("view")<CR>'
		exe "amenu  <silent> ".s:BASH_RootMenu.'.S&nippets.&write\ code\ snippet<Tab>'.esc_mapl.'nw      :call BASH_CodeSnippet("write")<CR>'
		exe "imenu  <silent> ".s:BASH_RootMenu.'.S&nippets.&write\ code\ snippet<Tab>'.esc_mapl.'nw <C-C>:call BASH_CodeSnippet("write")<CR>'
		exe "vmenu  <silent> ".s:BASH_RootMenu.'.S&nippets.&write\ code\ snippet<Tab>'.esc_mapl.'nw <C-C>:call BASH_CodeSnippet("writemarked")<CR>'
		exe "amenu  <silent> ".s:BASH_RootMenu.'.S&nippets.&edit\ code\ snippet<Tab>'.esc_mapl.'ne       :call BASH_CodeSnippet("edit")<CR>'
		exe "imenu  <silent> ".s:BASH_RootMenu.'.S&nippets.&edit\ code\ snippet<Tab>'.esc_mapl.'ne  <C-C>:call BASH_CodeSnippet("edit")<CR>'
		exe "amenu  <silent> ".s:BASH_RootMenu.'.S&nippets.-SepSnippets-                       :'
		"
	endif
	"
	call mmtemplates#core#CreateMenus ( 'g:BASH_Templates', s:BASH_RootMenu, 'do_specials', 'specials_menu', 'S&nippets' )
	"
	"-------------------------------------------------------------------------------
	" run     {{{2
	"-------------------------------------------------------------------------------
	" 
	exe " menu <silent> ".s:BASH_RootMenu.'.&Run.save\ +\ &run\ script<Tab><C-F9>\ \ '.esc_mapl.'rr            :call BASH_Run("n")<CR>'
	exe "imenu <silent> ".s:BASH_RootMenu.'.&Run.save\ +\ &run\ script<Tab><C-F9>\ \ '.esc_mapl.'rr       <C-C>:call BASH_Run("n")<CR>'
	"
	exe " menu          ".s:BASH_RootMenu.'.&Run.script\ cmd\.\ line\ &arg\.<Tab><S-F9>\ \ '.esc_mapl.'ra      :BashScriptArguments<Space>'
	exe "imenu          ".s:BASH_RootMenu.'.&Run.script\ cmd\.\ line\ &arg\.<Tab><S-F9>\ \ '.esc_mapl.'ra <C-C>:BashScriptArguments<Space>'
	"
	exe " menu          ".s:BASH_RootMenu.'.&Run.Bash\ cmd\.\ line\ &arg\.<Tab>'.esc_mapl.'rba                  :BashArguments<Space>'
	exe "imenu          ".s:BASH_RootMenu.'.&Run.Bash\ cmd\.\ line\ &arg\.<Tab>'.esc_mapl.'rba             <C-C>:BashArguments<Space>'
	"
  exe " menu <silent> ".s:BASH_RootMenu.'.&Run.update,\ check\ &syntax<Tab><A-F9>\ \ '.esc_mapl.'rc          :call BASH_SyntaxCheck()<CR>'
  exe "imenu <silent> ".s:BASH_RootMenu.'.&Run.update,\ check\ &syntax<Tab><A-F9>\ \ '.esc_mapl.'rc     <C-C>:call BASH_SyntaxCheck()<CR>'
	exe " menu <silent> ".s:BASH_RootMenu.'.&Run.syntax\ check\ o&ptions<Tab>'.esc_mapl.'rco               :call BASH_SyntaxCheckOptionsLocal()<CR>'
	exe "imenu <silent> ".s:BASH_RootMenu.'.&Run.syntax\ check\ o&ptions<Tab>'.esc_mapl.'rco          <C-C>:call BASH_SyntaxCheckOptionsLocal()<CR>'
	"
	let ahead = 'amenu <silent> '.s:BASH_RootMenu.'.Run.'
	let vhead = 'vmenu <silent> '.s:BASH_RootMenu.'.Run.'
  "
	"
	if	!s:MSWIN
		exe " menu <silent> ".s:BASH_RootMenu.'.&Run.start\ &debugger<Tab><F9>\ \ \\rd           :call BASH_Debugger()<CR>'
		exe "imenu <silent> ".s:BASH_RootMenu.'.&Run.start\ &debugger<Tab><F9>\ \ \\rd      <C-C>:call BASH_Debugger()<CR>'
		exe " menu <silent> ".s:BASH_RootMenu.'.&Run.make\ script\ &executable<Tab>\\re          :call BASH_MakeScriptExecutable()<CR>'
		exe "imenu <silent> ".s:BASH_RootMenu.'.&Run.make\ script\ &executable<Tab>\\re     <C-C>:call BASH_MakeScriptExecutable()<CR>'
	endif
	"
	exe ahead.'-SEP1-   :'
	if	s:MSWIN
		exe ahead.'&hardcopy\ to\ printer<Tab>'.esc_mapl.'rh        <C-C>:call BASH_Hardcopy("n")<CR>'
		exe vhead.'&hardcopy\ to\ printer<Tab>'.esc_mapl.'rh        <C-C>:call BASH_Hardcopy("v")<CR>'
	else
		exe ahead.'&hardcopy\ to\ FILENAME\.ps<Tab>'.esc_mapl.'rh   <C-C>:call BASH_Hardcopy("n")<CR>'
		exe vhead.'&hardcopy\ to\ FILENAME\.ps<Tab>'.esc_mapl.'rh   <C-C>:call BASH_Hardcopy("v")<CR>'
	endif
	"
	exe ahead.'-SEP2-                                                 :'
	exe ahead.'plugin\ &settings<Tab>'.esc_mapl.'rs                   :call BASH_Settings()<CR>'
	"
	if	!s:MSWIN
		exe " menu  <silent>  ".s:BASH_RootMenu.'.&Run.x&term\ size<Tab>'.esc_mapl.'rx                       :call BASH_XtermSize()<CR>'
		exe "imenu  <silent>  ".s:BASH_RootMenu.'.&Run.x&term\ size<Tab>'.esc_mapl.'rx                  <C-C>:call BASH_XtermSize()<CR>'
	endif
	"
	if	s:MSWIN
		if s:BASH_OutputGvim == "buffer"
			exe " menu  <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ BUFFER->term<Tab>'.esc_mapl.'ro          :call BASH_Toggle_Gvim_Xterm_MS()<CR>'
			exe "imenu  <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ BUFFER->term<Tab>'.esc_mapl.'ro     <C-C>:call BASH_Toggle_Gvim_Xterm_MS()<CR>'
		else
			exe " menu  <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ TERM->buffer<Tab>'.esc_mapl.'ro          :call BASH_Toggle_Gvim_Xterm_MS()<CR>'
			exe "imenu  <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ TERM->buffer<Tab>'.esc_mapl.'ro     <C-C>:call BASH_Toggle_Gvim_Xterm_MS()<CR>'
		endif
	else
		if s:BASH_OutputGvim == "vim"
			exe " menu  <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ VIM->buffer->xterm<Tab>'.esc_mapl.'ro          :call BASH_Toggle_Gvim_Xterm()<CR>'
			exe "imenu  <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ VIM->buffer->xterm<Tab>'.esc_mapl.'ro     <C-C>:call BASH_Toggle_Gvim_Xterm()<CR>'
		else
			if s:BASH_OutputGvim == "buffer"
				exe " menu  <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ BUFFER->xterm->vim<Tab>'.esc_mapl.'ro        :call BASH_Toggle_Gvim_Xterm()<CR>'
				exe "imenu  <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ BUFFER->xterm->vim<Tab>'.esc_mapl.'ro   <C-C>:call BASH_Toggle_Gvim_Xterm()<CR>'
			else
				exe " menu  <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ XTERM->vim->buffer<Tab>'.esc_mapl.'ro        :call BASH_Toggle_Gvim_Xterm()<CR>'
				exe "imenu  <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ XTERM->vim->buffer<Tab>'.esc_mapl.'ro   <C-C>:call BASH_Toggle_Gvim_Xterm()<CR>'
			endif
		endif
	endif
	"
 	"-------------------------------------------------------------------------------
 	" comments     {{{2
 	"-------------------------------------------------------------------------------
	exe " noremenu ".s:BASH_RootMenu.'.&Comments.&echo\ "<line>"<Tab>\\ce       :call BASH_echo_comment()<CR>j'
	exe "inoremenu ".s:BASH_RootMenu.'.&Comments.&echo\ "<line>"<Tab>\\ce  <C-C>:call BASH_echo_comment()<CR>j'
	exe " noremenu ".s:BASH_RootMenu.'.&Comments.&remove\ echo<Tab>\\cr         :call BASH_remove_echo()<CR>j'
	exe "inoremenu ".s:BASH_RootMenu.'.&Comments.&remove\ echo<Tab>\\cr    <C-C>:call BASH_remove_echo()<CR>j'
	"
 	"-------------------------------------------------------------------------------
 	" help     {{{2
 	"-------------------------------------------------------------------------------
	"
	exe " menu  <silent>  ".s:BASH_RootMenu.'.&Help.&Bash\ manual<Tab>'.esc_mapl.'hb                    :call BASH_help("bash")<CR>'
	exe "imenu  <silent>  ".s:BASH_RootMenu.'.&Help.&Bash\ manual<Tab>'.esc_mapl.'hb               <C-C>:call BASH_help("bash")<CR>'
	"                                  
	exe " menu  <silent>  ".s:BASH_RootMenu.'.&Help.&help\ (Bash\ builtins)<Tab>'.esc_mapl.'hh          :call BASH_help("help")<CR>'
	exe "imenu  <silent>  ".s:BASH_RootMenu.'.&Help.&help\ (Bash\ builtins)<Tab>'.esc_mapl.'hh     <C-C>:call BASH_help("help")<CR>'
	"                                  
	exe " menu  <silent>  ".s:BASH_RootMenu.'.&Help.&manual\ (utilities)<Tab>'.esc_mapl.'hm             :call BASH_help("man")<CR>'
	exe "imenu  <silent>  ".s:BASH_RootMenu.'.&Help.&manual\ (utilities)<Tab>'.esc_mapl.'hm        <C-C>:call BASH_help("man")<CR>'
	"                                  
	exe " menu  <silent>  ".s:BASH_RootMenu.'.&Help.-SEP1-                                              :'
	exe " menu  <silent>  ".s:BASH_RootMenu.'.&Help.help\ (Bash-&Support)<Tab>'.esc_mapl.'hbs           :call BASH_HelpBashSupport()<CR>'
	exe "imenu  <silent>  ".s:BASH_RootMenu.'.&Help.help\ (Bash-&Support)<Tab>'.esc_mapl.'hbs      <C-C>:call BASH_HelpBashSupport()<CR>'
	"
endfunction    " ----------  end of function s:InitMenus  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_JumpForward     {{{1
"   DESCRIPTION:  Jump to the next target, otherwise behind the current string.
"    PARAMETERS:  -
"       RETURNS:  empty string
"===============================================================================
function! BASH_JumpForward ()
  let match	= search( s:BASH_TemplateJumpTarget, 'c' )
	if match > 0
		" remove the target
		call setline( match, substitute( getline('.'), s:BASH_TemplateJumpTarget, '', '' ) )
	else
		" try to jump behind parenthesis or strings
		call search( "[\]})\"'`]", 'W' )
		normal l
	endif
	return ''
endfunction    " ----------  end of function BASH_JumpForward  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_CodeSnippet     {{{1
"   DESCRIPTION:  read / write / edit code sni
"    PARAMETERS:  mode - edit, read, write, writemarked, view
"===============================================================================
function! BASH_CodeSnippet(mode)
  if isdirectory(g:BASH_CodeSnippets)
    "
    " read snippet file, put content below current line
    "
    if a:mode == "read"
			if has("gui_running") && s:BASH_GuiSnippetBrowser == 'gui'
				let l:snippetfile=browse(0,"read a code snippet",g:BASH_CodeSnippets,"")
			else
				let	l:snippetfile=input("read snippet ", g:BASH_CodeSnippets, "file" )
			endif
      if filereadable(l:snippetfile)
        let linesread= line("$")
        let l:old_cpoptions = &cpoptions " Prevent the alternate buffer from being set to this files
        setlocal cpoptions-=a
        :execute "read ".l:snippetfile
        let &cpoptions  = l:old_cpoptions   " restore previous options
        "
        let linesread= line("$")-linesread-1
        if linesread>=0 && match( l:snippetfile, '\.\(ni\|noindent\)$' ) < 0
          silent exe "normal =".linesread."+"
        endif
      endif
    endif
    "
    " update current buffer / split window / edit snippet file
    "
    if a:mode == "edit"
			if has("gui_running") && s:BASH_GuiSnippetBrowser == 'gui'
				let l:snippetfile=browse(0,"edit a code snippet",g:BASH_CodeSnippets,"")
			else
				let	l:snippetfile=input("edit snippet ", g:BASH_CodeSnippets, "file" )
			endif
      if !empty(l:snippetfile)
        :execute "update! | split | edit ".l:snippetfile
      endif
    endif
    "
    " update current buffer / split window / view snippet file
    "
    if a:mode == "view"
			if has("gui_running") && s:BASH_GuiSnippetBrowser == 'gui'
				let l:snippetfile=browse(0,"view a code snippet",g:BASH_CodeSnippets,"")
			else
				let	l:snippetfile=input("view snippet ", g:BASH_CodeSnippets, "file" )
			endif
      if !empty(l:snippetfile)
        :execute "update! | split | view ".l:snippetfile
      endif
    endif
    "
    " write whole buffer or marked area into snippet file
    "
    if a:mode == "write" || a:mode == "writemarked"
			if has("gui_running") && s:BASH_GuiSnippetBrowser == 'gui'
				let l:snippetfile=browse(0,"write a code snippet",g:BASH_CodeSnippets,"")
			else
				let	l:snippetfile=input("write snippet ", g:BASH_CodeSnippets, "file" )
			endif
      if !empty(l:snippetfile)
        if filereadable(l:snippetfile)
          if confirm("File ".l:snippetfile." exists ! Overwrite ? ", "&Cancel\n&No\n&Yes") != 3
            return
          endif
        endif
				if a:mode == "write"
					:execute ":write! ".l:snippetfile
				else
					:execute ":*write! ".l:snippetfile
				endif
      endif
    endif

  else
    redraw!
    echohl ErrorMsg
    echo "code snippet directory ".g:BASH_CodeSnippets." does not exist"
    echohl None
  endif
endfunction   " ---------- end of function  BASH_CodeSnippet  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_Hardcopy     {{{1
"   DESCRIPTION:  Make PostScript document from current buffer
"                 MSWIN : display printer dialog
"    PARAMETERS:  mode - n : print complete buffer, v : print marked area
"       RETURNS:  
"===============================================================================
function! BASH_Hardcopy (mode)
  let outfile = expand("%")
  if outfile == ""
    redraw
    echohl WarningMsg | echo " no file name " | echohl None
    return
  endif
	let outdir	= getcwd()
	if filewritable(outdir) != 2
		let outdir	= $HOME
	endif
	if  !s:MSWIN
		let outdir	= outdir.'/'
	endif
  let old_printheader=&printheader
  exe  ':set printheader='.s:BASH_Printheader
  " ----- normal mode ----------------
  if a:mode=="n"
    silent exe  'hardcopy > '.outdir.outfile.'.ps'
    if  !s:MSWIN
      echo 'file "'.outfile.'" printed to "'.outdir.outfile.'.ps"'
    endif
  endif
  " ----- visual mode ----------------
  if a:mode=="v"
    silent exe  "*hardcopy > ".outdir.outfile.".ps"
    if  !s:MSWIN
      echo 'file "'.outfile.'" (lines '.line("'<").'-'.line("'>").') printed to "'.outdir.outfile.'.ps"'
    endif
  endif
  exe  ':set printheader='.escape( old_printheader, ' %' )
endfunction   " ---------- end of function  BASH_Hardcopy  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  CreateAdditionalMaps     {{{1
"   DESCRIPTION:  create additional maps
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! s:CreateAdditionalMaps ()
	"
	" ---------- Bash dictionary -------------------------------------------------
	" This will enable keyword completion for Bash
	" using Vim's dictionary feature |i_CTRL-X_CTRL-K|.
	"
	if exists("g:BASH_Dictionary_File")
		silent! exe 'setlocal dictionary+='.g:BASH_Dictionary_File
	endif
	"
	"-------------------------------------------------------------------------------
	" USER DEFINED COMMANDS
	"-------------------------------------------------------------------------------
	command! -nargs=* -complete=file BashScriptArguments  call BASH_ScriptCmdLineArguments(<q-args>)
	command! -nargs=* -complete=file BashArguments        call BASH_BashCmdLineArguments(<q-args>)
	"
	"-------------------------------------------------------------------------------
	" settings - local leader
	"-------------------------------------------------------------------------------
	if ! empty ( g:BASH_MapLeader )
		if exists ( 'g:maplocalleader' )
			let ll_save = g:maplocalleader
		endif
		let g:maplocalleader = g:BASH_MapLeader
	endif
	"
	"-------------------------------------------------------------------------------
	" comments
	"-------------------------------------------------------------------------------
	nnoremap  <buffer>  <silent>  <LocalLeader>cl         :call BASH_EndOfLineComment()<CR>
	inoremap  <buffer>  <silent>  <LocalLeader>cl    <C-C>:call BASH_EndOfLineComment()<CR>
	vnoremap  <buffer>  <silent>  <LocalLeader>cl         :call BASH_EndOfLineComment()<CR>
	"
	nnoremap  <buffer>  <silent>  <LocalLeader>cj         :call BASH_AdjustLineEndComm()<CR>
	inoremap  <buffer>  <silent>  <LocalLeader>cj    <C-C>:call BASH_AdjustLineEndComm()<CR>
	vnoremap  <buffer>  <silent>  <LocalLeader>cj         :call BASH_AdjustLineEndComm()<CR>
	"
	nnoremap  <buffer>  <silent>  <LocalLeader>cs         :call BASH_GetLineEndCommCol()<CR>
	inoremap  <buffer>  <silent>  <LocalLeader>cs    <C-C>:call BASH_GetLineEndCommCol()<CR>
	vnoremap  <buffer>  <silent>  <LocalLeader>cs    <C-C>:call BASH_GetLineEndCommCol()<CR>
	"
	nnoremap  <buffer>  <silent>  <LocalLeader>cc         :call BASH_CodeComment()<CR>
	inoremap  <buffer>  <silent>  <LocalLeader>cc    <C-C>:call BASH_CodeComment()<CR>
	vnoremap  <buffer>  <silent>  <LocalLeader>cc         :call BASH_CodeComment()<CR>
	"
	nnoremap  <buffer>  <silent>  <LocalLeader>cu         :call BASH_CommentCode(0)<CR>
	inoremap  <buffer>  <silent>  <LocalLeader>cu    <C-C>:call BASH_CommentCode(0)<CR>
	vnoremap  <buffer>  <silent>  <LocalLeader>cu         :call BASH_CommentCode(0)<CR>
	"
   noremap  <buffer>  <silent>  <LocalLeader>ce         :call BASH_echo_comment()<CR>j'
  inoremap  <buffer>  <silent>  <LocalLeader>ce    <C-C>:call BASH_echo_comment()<CR>j'
   noremap  <buffer>  <silent>  <LocalLeader>cr         :call BASH_remove_echo()<CR>j'
  inoremap  <buffer>  <silent>  <LocalLeader>cr    <C-C>:call BASH_remove_echo()<CR>j'
	"
	"-------------------------------------------------------------------------------
	" snippets
	"-------------------------------------------------------------------------------
	"
	nnoremap    <buffer>  <silent>  <LocalLeader>nr         :call BASH_CodeSnippet("read")<CR>
	inoremap    <buffer>  <silent>  <LocalLeader>nr    <Esc>:call BASH_CodeSnippet("read")<CR>
	nnoremap    <buffer>  <silent>  <LocalLeader>nw         :call BASH_CodeSnippet("write")<CR>
	inoremap    <buffer>  <silent>  <LocalLeader>nw    <Esc>:call BASH_CodeSnippet("write")<CR>
	vnoremap    <buffer>  <silent>  <LocalLeader>nw    <Esc>:call BASH_CodeSnippet("writemarked")<CR>
	nnoremap    <buffer>  <silent>  <LocalLeader>ne         :call BASH_CodeSnippet("edit")<CR>
	inoremap    <buffer>  <silent>  <LocalLeader>ne    <Esc>:call BASH_CodeSnippet("edit")<CR>
	nnoremap    <buffer>  <silent>  <LocalLeader>nv         :call BASH_CodeSnippet("view")<CR>
	inoremap    <buffer>  <silent>  <LocalLeader>nv    <Esc>:call BASH_CodeSnippet("view")<CR>
	"
	"-------------------------------------------------------------------------------
	"   run
	"-------------------------------------------------------------------------------
	"
	 noremap    <buffer>  <silent>  <LocalLeader>rr        :call BASH_Run("n")<CR>
	inoremap    <buffer>  <silent>  <LocalLeader>rr   <Esc>:call BASH_Run("n")<CR>
	 noremap    <buffer>  <silent>  <LocalLeader>rc        :call BASH_SyntaxCheck()<CR>
	inoremap    <buffer>  <silent>  <LocalLeader>rc   <C-C>:call BASH_SyntaxCheck()<CR>
	 noremap    <buffer>  <silent>  <LocalLeader>rco       :call BASH_SyntaxCheckOptionsLocal()<CR>
	inoremap    <buffer>  <silent>  <LocalLeader>rco  <C-C>:call BASH_SyntaxCheckOptionsLocal()<CR>
	 noremap    <buffer>            <LocalLeader>ra        :BashScriptArguments<Space>
	inoremap    <buffer>            <LocalLeader>ra   <Esc>:BashScriptArguments<Space>
   noremap    <buffer>            <LocalLeader>rba       :BashArguments<Space>
 	inoremap    <buffer>            <LocalLeader>rba  <Esc>:BashArguments<Space>
	"
	if s:UNIX
		 noremap    <buffer>  <silent>  <LocalLeader>re        :call BASH_MakeScriptExecutable()<CR>
		inoremap    <buffer>  <silent>  <LocalLeader>re   <C-C>:call BASH_MakeScriptExecutable()<CR>
	endif
	nnoremap    <buffer>  <silent>  <LocalLeader>rh        :call BASH_Hardcopy("n")<CR>
	vnoremap    <buffer>  <silent>  <LocalLeader>rh   <C-C>:call BASH_Hardcopy("v")<CR>
  "
   map  <buffer>  <silent>  <C-F9>        :call BASH_Run("n")<CR>
  imap  <buffer>  <silent>  <C-F9>   <C-C>:call BASH_Run("n")<CR>
		"
   map  <buffer>  <silent>  <A-F9>        :call BASH_SyntaxCheck()<CR>
  imap  <buffer>  <silent>  <A-F9>   <C-C>:call BASH_SyntaxCheck()<CR>
  "
  map   <buffer>            <S-F9>        :BashScriptArguments<Space>
  imap  <buffer>            <S-F9>   <C-C>:BashScriptArguments<Space>

	if s:MSWIN
 		 map  <buffer>  <silent>  <LocalLeader>ro           :call BASH_Toggle_Gvim_Xterm_MS()<CR>
		imap  <buffer>  <silent>  <LocalLeader>ro      <Esc>:call BASH_Toggle_Gvim_Xterm_MS()<CR>
	else
		 map  <buffer>  <silent>  <LocalLeader>ro           :call BASH_Toggle_Gvim_Xterm()<CR>
		imap  <buffer>  <silent>  <LocalLeader>ro      <Esc>:call BASH_Toggle_Gvim_Xterm()<CR>
		 map  <buffer>  <silent>  <LocalLeader>rd           :call BASH_Debugger()<CR>
		imap  <buffer>  <silent>  <LocalLeader>rd      <Esc>:call BASH_Debugger()<CR>
     map  <buffer>  <silent>    <F9>                    :call BASH_Debugger()<CR>
    imap  <buffer>  <silent>    <F9>               <C-C>:call BASH_Debugger()<CR>
		if has("gui_running")
			 map  <buffer>  <silent>  <LocalLeader>rx         :call BASH_XtermSize()<CR>
			imap  <buffer>  <silent>  <LocalLeader>rx    <Esc>:call BASH_XtermSize()<CR>
		endif
	endif
	"
	"-------------------------------------------------------------------------------
	"   help
	"-------------------------------------------------------------------------------
	nnoremap  <buffer>  <silent>  <LocalLeader>rs         :call BASH_Settings()<CR>
  "
   noremap  <buffer>  <silent>  <LocalLeader>hb         :call BASH_help('bash')<CR>
  inoremap  <buffer>  <silent>  <LocalLeader>hb    <Esc>:call BASH_help('bash')<CR>
   noremap  <buffer>  <silent>  <LocalLeader>hh         :call BASH_help('help')<CR>
  inoremap  <buffer>  <silent>  <LocalLeader>hh    <Esc>:call BASH_help('man')<CR>
   noremap  <buffer>  <silent>  <LocalLeader>hm         :call BASH_help('man')<CR>
  inoremap  <buffer>  <silent>  <LocalLeader>hm    <Esc>:call BASH_help('help')<CR>
	 noremap  <buffer>  <silent>  <LocalLeader>hbs        :call BASH_HelpBashSupport()<CR>
	inoremap  <buffer>  <silent>  <LocalLeader>hbs   <C-C>:call BASH_HelpBashSupport()<CR>
	"
	nmap    <buffer>  <silent>  <C-j>    i<C-R>=BASH_JumpForward()<CR>
	imap    <buffer>  <silent>  <C-j>     <C-R>=BASH_JumpForward()<CR>
	"
	"-------------------------------------------------------------------------------
	" settings - reset local leader
	"-------------------------------------------------------------------------------
	if ! empty ( g:BASH_MapLeader )
		if exists ( 'll_save' )
			let g:maplocalleader = ll_save
		else
			unlet g:maplocalleader
		endif
	endif
	"
endfunction    " ----------  end of function s:CreateAdditionalMaps  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_HelpBashSupport     {{{1
"   DESCRIPTION:  help bash-support
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_HelpBashSupport ()
	try
		:help bashsupport
	catch
		exe ':helptags '.s:plugin_dir.'/doc'
		:help bashsupport
	endtry
endfunction    " ----------  end of function BASH_HelpBashSupport ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_help     {{{1
"   DESCRIPTION:  lookup word under the cursor or ask
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
let s:BASH_DocBufferName       = "BASH_HELP"
let s:BASH_DocHelpBufferNumber = -1
"
function! BASH_help( type )

	let cuc		= getline(".")[col(".") - 1]		" character under the cursor
	let	item	= expand("<cword>")							" word under the cursor
	if empty(item) || match( item, cuc ) == -1
		if a:type == 'man'
			let	item=BASH_Input('[tab compl. on] name of command line utility : ', '', 'shellcmd' )
		endif
		if a:type == 'help'
			let	item=BASH_Input('[tab compl. on] name of bash builtin : ', '', 'customlist,BASH_BuiltinComplete' )
		endif
	endif

	if empty(item) &&  a:type != 'bash'
		return
	endif
	"------------------------------------------------------------------------------
	"  replace buffer content with bash help text
	"------------------------------------------------------------------------------
	"
	" jump to an already open bash help window or create one
	"
	if bufloaded(s:BASH_DocBufferName) != 0 && bufwinnr(s:BASH_DocHelpBufferNumber) != -1
		exe bufwinnr(s:BASH_DocHelpBufferNumber) . "wincmd w"
		" buffer number may have changed, e.g. after a 'save as'
		if bufnr("%") != s:BASH_DocHelpBufferNumber
			let s:BASH_DocHelpBufferNumber=bufnr(s:BASH_OutputBufferName)
			exe ":bn ".s:BASH_DocHelpBufferNumber
		endif
	else
		exe ":new ".s:BASH_DocBufferName
		let s:BASH_DocHelpBufferNumber=bufnr("%")
		setlocal buftype=nofile
		setlocal noswapfile
		setlocal bufhidden=delete
		setlocal syntax=OFF
	endif
	setlocal	modifiable
	setlocal filetype=man
	"
	"-------------------------------------------------------------------------------
	" read Bash help
	"-------------------------------------------------------------------------------
	if a:type == 'help'
		setlocal wrap
		silent exe ":%!help -m ".item
	endif
	"
	"-------------------------------------------------------------------------------
	" open a manual (utilities)
	"-------------------------------------------------------------------------------
	if a:type == 'man'
		"
		" Is there more than one manual ?
		"
		let manpages	= system( s:BASH_ManualReader.' -k '.item )
		if v:shell_error
			echomsg	"shell command '".s:BASH_ManualReader." -k ".item."' failed"
			:close
			return
		endif
		let	catalogs	= split( manpages, '\n', )
		let	manual		= {}
		"
		" Select manuals where the name exactly matches
		"
		for line in catalogs
			if line =~ '^'.item.'\s\+('
				let	itempart	= split( line, '\s\+' )
				let	catalog		= itempart[1][1:-2]
				let	manual[catalog]	= catalog
			endif
		endfor
		"
		" Build a selection list if there are more than one manual
		"
		let	catalog	= ""
		if len(keys(manual)) > 1
			for key in keys(manual)
				echo ' '.item.'  '.key
			endfor
			let defaultcatalog	= ''
			if has_key( manual, '1' )
				let defaultcatalog	= '1'
			else
				if has_key( manual, '8' )
					let defaultcatalog	= '8'
				endif
			endif
			let	catalog	= input( 'select manual section (<Enter> cancels) : ', defaultcatalog )
			if ! has_key( manual, catalog )
				:close
				:redraw
				echomsg	"no appropriate manual section '".catalog."'"
				return
			endif
		endif

		silent exe ":%!".s:BASH_ManualReader.' '.catalog.' '.item

		if s:MSWIN
			call s:bash_RemoveSpecialCharacters()
		endif

	endif
	"
	"-------------------------------------------------------------------------------
	" open the bash manual
	"-------------------------------------------------------------------------------
	if a:type == 'bash'
		silent exe ":%!".s:BASH_ManualReader.' 1 bash'

		if s:MSWIN
			call s:bash_RemoveSpecialCharacters()
		endif
	endif

	setlocal nomodifiable
endfunction		" ---------- end of function  BASH_help  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  Bash_RemoveSpecialCharacters     {{{1
"   DESCRIPTION:  remove <backspace><any character> in CYGWIN man(1) output
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! s:bash_RemoveSpecialCharacters ( )
	let	patternunderline	= '_\%x08'
	let	patternbold				= '\%x08.'
	setlocal modifiable
	if search(patternunderline) != 0
		silent exe ':%s/'.patternunderline.'//g'
	endif
	if search(patternbold) != 0
		silent exe ':%s/'.patternbold.'//g'
	endif
	setlocal nomodifiable
	silent normal gg
endfunction		" ---------- end of function  s:bash_RemoveSpecialCharacters   ----------
"
"------------------------------------------------------------------------------
"  Bash shopt options
"------------------------------------------------------------------------------
"
"===  FUNCTION  ================================================================
"          NAME:  Bash_find_option     {{{1
"   DESCRIPTION:  check if local options does exist
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! s:bash_find_option ( list, option )
	for item in a:list
		if item == a:option
			return 0
		endif
	endfor
	return -1
endfunction    " ----------  end of function s:bash_find_option  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_SyntaxCheckOptions     {{{1
"   DESCRIPTION:  Syntax Check, options
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_SyntaxCheckOptions( options )
	let startpos=0
	while startpos < strlen( a:options )
		" match option switch ' -O ' or ' +O '
		let startpos		= matchend ( a:options, '\s*[+-]O\s\+', startpos )
		" match option name
		let optionname	= matchstr ( a:options, '\h\w*\s*', startpos )
		" remove trailing whitespaces
		let optionname  = substitute ( optionname, '\s\+$', "", "" )
		" check name
		" increment start position for next search
		let startpos		=  matchend  ( a:options, '\h\w*\s*', startpos )
	endwhile
	return 0
endfunction		" ---------- end of function  BASH_SyntaxCheckOptions----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_SyntaxCheckOptionsLocal     {{{1
"   DESCRIPTION:  Syntax Check, local options
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_SyntaxCheckOptionsLocal ()
	let filename = expand("%")
  if empty(filename)
		redraw
		echohl WarningMsg | echo " no file name or not a shell file " | echohl None
		return
  endif
	let	prompt	= 'syntax check options for "'.filename.'" : '

	if exists("b:BASH_SyntaxCheckOptionsLocal")
		let	b:BASH_SyntaxCheckOptionsLocal= BASH_Input( prompt, b:BASH_SyntaxCheckOptionsLocal, '' )
	else
		let	b:BASH_SyntaxCheckOptionsLocal= BASH_Input( prompt , "", '' )
	endif

	if BASH_SyntaxCheckOptions( b:BASH_SyntaxCheckOptionsLocal ) != 0
		let b:BASH_SyntaxCheckOptionsLocal	= ""
	endif
endfunction		" ---------- end of function  BASH_SyntaxCheckOptionsLocal  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_Settings     {{{1
"   DESCRIPTION:  Display plugin settings
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_Settings ()
	let	txt =     " Bash-Support settings\n\n"
	let txt = txt.'                    author :  "'.mmtemplates#core#ExpandText( g:BASH_Templates, '|AUTHOR|'      )."\"\n"
	let txt = txt.'                 authorref :  "'.mmtemplates#core#ExpandText( g:BASH_Templates, '|AUTHORREF|'   )."\"\n"
	let txt = txt.'                   company :  "'.mmtemplates#core#ExpandText( g:BASH_Templates, '|COMPANY|'     )."\"\n"
	let txt = txt.'          copyright holder :  "'.mmtemplates#core#ExpandText( g:BASH_Templates, '|COPYRIGHT|'   )."\"\n"
	let txt = txt.'                     email :  "'.mmtemplates#core#ExpandText( g:BASH_Templates, '|EMAIL|'       )."\"\n"
  let txt = txt.'                   licence :  "'.mmtemplates#core#ExpandText( g:BASH_Templates, '|LICENSE|'     )."\"\n"
	let txt = txt.'              organization :  "'.mmtemplates#core#ExpandText( g:BASH_Templates, '|ORGANIZATION|')."\"\n"
	let txt = txt.'                   project :  "'.mmtemplates#core#ExpandText( g:BASH_Templates, '|PROJECT|'     )."\"\n"
	let txt = txt.'           Bash executable :  '.s:BASH_BASH."\n"
	if exists( "b:BASH_BashCmdLineArgs" )
		let txt = txt.'  Bash cmd. line arguments :  '.b:BASH_BashCmdLineArgs."\n"
	endif
	let txt = txt.'       plugin installation :  "'.s:installation."\"\n"
 	let txt = txt.'    code snippet directory :  "'.s:BASH_CodeSnippets."\"\n"
	if s:installation == 'system'
		let txt = txt.' global template directory :  '.s:BASH_GlobalTemplateDir."\n"
		if filereadable( s:BASH_LocalTemplateFile )
			let txt = txt.' local template directory :  '.s:BASH_LocalTemplateDir."\n"
		endif
	else
		let txt = txt.'  local template directory :  '.s:BASH_LocalTemplateDir."\n"
	endif
	let txt = txt.'glob. syntax check options :  "'.s:BASH_SyntaxCheckOptionsGlob."\"\n"
	if exists("b:BASH_SyntaxCheckOptionsLocal")
		let txt = txt.' buf. syntax check options :  "'.b:BASH_SyntaxCheckOptionsLocal."\"\n"
	endif
	" ----- dictionaries ------------------------
  if !empty(g:BASH_Dictionary_File)
		let ausgabe= &dictionary
		let ausgabe= substitute( ausgabe, ",", ",\n                            + ", "g" )
		let txt = txt."        dictionary file(s) :  ".ausgabe."\n"
	endif
	" ----- Bash commandline arguments ------------------------
	if exists("b:BASH_BashCmdLineArgs")
		let ausgabe = b:BASH_BashCmdLineArgs
	else
		let ausgabe = ""
	endif
	let txt = txt." Bash cmd.line argument(s) :  ".ausgabe."\n"
	let txt = txt."\n"
	let	txt = txt."__________________________________________________________________________\n"
	let	txt = txt." bash-support, version ".g:BASH_Version." / Dr.-Ing. Fritz Mehner / mehner.fritz@fh-swf.de\n\n"
	echo txt
endfunction    " ----------  end of function BASH_Settings ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_CreateGuiMenus     {{{1
"   DESCRIPTION:  
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_CreateGuiMenus ()
	if s:BASH_MenuVisible == 'no'
		aunmenu <silent> &Tools.Load\ Bash\ Support
		amenu   <silent> 40.1000 &Tools.-SEP100- :
		amenu   <silent> 40.1010 &Tools.Unload\ Bash\ Support :call BASH_RemoveGuiMenus()<CR>
		"
		call g:BASH_RereadTemplates('no')
		call s:InitMenus () 
		"
		let s:BASH_MenuVisible = 'yes'
	endif
endfunction    " ----------  end of function BASH_CreateGuiMenus  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_ToolMenu     {{{1
"   DESCRIPTION:  
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_ToolMenu ()
	amenu   <silent> 40.1000 &Tools.-SEP100- :
	amenu   <silent> 40.1010 &Tools.Load\ Bash\ Support :call BASH_CreateGuiMenus()<CR>
endfunction    " ----------  end of function BASH_ToolMenu  ----------

"===  FUNCTION  ================================================================
"          NAME:  BASH_RemoveGuiMenus     {{{1
"   DESCRIPTION:  
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_RemoveGuiMenus ()
	if s:BASH_MenuVisible == 'yes'
		exe "aunmenu <silent> ".s:BASH_RootMenu
		"
		aunmenu <silent> &Tools.Unload\ Bash\ Support
		call BASH_ToolMenu()
		"
		let s:BASH_MenuVisible = 'no'
	endif
endfunction    " ----------  end of function BASH_RemoveGuiMenus  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_Toggle_Gvim_Xterm     {{{1
"   DESCRIPTION:  toggle output destination (Linux/Unix)
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_Toggle_Gvim_Xterm ()

	if has("gui_running")
		let [ esc_mapl, err ] = mmtemplates#core#Resource ( g:BASH_Templates, 'escaped_mapleader' )
		if s:BASH_OutputGvim == "vim"
			exe "aunmenu  <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ VIM->buffer->xterm'
			exe " menu    <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ BUFFER->xterm->vim<Tab>'.esc_mapl.'ro          :call BASH_Toggle_Gvim_Xterm()<CR>'
			exe "imenu    <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ BUFFER->xterm->vim<Tab>'.esc_mapl.'ro     <C-C>:call BASH_Toggle_Gvim_Xterm()<CR>'
			let	s:BASH_OutputGvim	= "buffer"
		else
			if s:BASH_OutputGvim == "buffer"
				exe "aunmenu  <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ BUFFER->xterm->vim'
				exe " menu    <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ XTERM->vim->buffer<Tab>'.esc_mapl.'ro        :call BASH_Toggle_Gvim_Xterm()<CR>'
				exe "imenu    <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ XTERM->vim->buffer<Tab>'.esc_mapl.'ro   <C-C>:call BASH_Toggle_Gvim_Xterm()<CR>'
				let	s:BASH_OutputGvim	= "xterm"
			else
				" ---------- output : xterm -> gvim
				exe "aunmenu  <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ XTERM->vim->buffer'
				exe " menu    <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ VIM->buffer->xterm<Tab>'.esc_mapl.'ro        :call BASH_Toggle_Gvim_Xterm()<CR>'
				exe "imenu    <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ VIM->buffer->xterm<Tab>'.esc_mapl.'ro   <C-C>:call BASH_Toggle_Gvim_Xterm()<CR>'
				let	s:BASH_OutputGvim	= "vim"
			endif
		endif
	else
		if s:BASH_OutputGvim == "vim"
			let	s:BASH_OutputGvim	= "buffer"
		else
			let	s:BASH_OutputGvim	= "vim"
		endif
	endif
	echomsg "output destination is '".s:BASH_OutputGvim."'"

endfunction    " ----------  end of function BASH_Toggle_Gvim_Xterm ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_Toggle_Gvim_Xterm_MS     {{{1
"   DESCRIPTION:  toggle output destination (Windows)
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_Toggle_Gvim_Xterm_MS ()
	if has("gui_running")
		let [ esc_mapl, err ] = mmtemplates#core#Resource ( g:BASH_Templates, 'escaped_mapleader' )
		if s:BASH_OutputGvim == "buffer"
			exe "aunmenu  <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ BUFFER->term'
			exe " menu    <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ TERM->buffer<Tab>'.esc_mapl.'ro         :call BASH_Toggle_Gvim_Xterm_MS()<CR>'
			exe "imenu    <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ TERM->buffer<Tab>'.esc_mapl.'ro    <C-C>:call BASH_Toggle_Gvim_Xterm_MS()<CR>'
			let	s:BASH_OutputGvim	= "xterm"
		else
			exe "aunmenu  <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ TERM->buffer'
			exe " menu    <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ BUFFER->term<Tab>'.esc_mapl.'ro         :call BASH_Toggle_Gvim_Xterm_MS()<CR>'
			exe "imenu    <silent>  ".s:BASH_RootMenu.'.&Run.&output:\ BUFFER->term<Tab>'.esc_mapl.'ro    <C-C>:call BASH_Toggle_Gvim_Xterm_MS()<CR>'
			let	s:BASH_OutputGvim	= "buffer"
		endif
	endif
endfunction    " ----------  end of function BASH_Toggle_Gvim_Xterm_MS ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_XtermSize     {{{1
"   DESCRIPTION:  set xterm size
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_XtermSize ()
	let regex	= '-geometry\s\+\d\+x\d\+'
	let geom	= matchstr( s:BASH_XtermDefaults, regex )
	let geom	= matchstr( geom, '\d\+x\d\+' )
	let geom	= substitute( geom, 'x', ' ', "" )
	let	answer= BASH_Input("   xterm size (COLUMNS LINES) : ", geom, '' )
	while match(answer, '^\s*\d\+\s\+\d\+\s*$' ) < 0
		let	answer= BASH_Input(" + xterm size (COLUMNS LINES) : ", geom, '' )
	endwhile
	let answer  = substitute( answer, '^\s\+', "", "" )		 				" remove leading whitespaces
	let answer  = substitute( answer, '\s\+$', "", "" )						" remove trailing whitespaces
	let answer  = substitute( answer, '\s\+', "x", "" )						" replace inner whitespaces
	let s:BASH_XtermDefaults	= substitute( s:BASH_XtermDefaults, regex, "-geometry ".answer , "" )
endfunction		" ---------- end of function  BASH_XtermSize  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_SaveOption     {{{1
"   DESCRIPTION:  save option
"    PARAMETERS:  option name
"                 characters to be escaped (optional)
"       RETURNS:  
"===============================================================================
function! BASH_SaveOption ( option, ... )
	exe 'let escaped =&'.a:option
	if a:0 == 0
		let escaped	= escape( escaped, ' |"\' )
	else
		let escaped	= escape( escaped, ' |"\'.a:1 )
	endif
	let s:BASH_saved_option[a:option]	= escaped
endfunction    " ----------  end of function BASH_SaveOption  ----------
"
let s:BASH_saved_option					= {}
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_RestoreOption     {{{1
"   DESCRIPTION:  restore option
"    PARAMETERS:  option name
"       RETURNS:  
"===============================================================================
function! BASH_RestoreOption ( option )
	exe ':setlocal '.a:option.'='.s:BASH_saved_option[a:option]
endfunction    " ----------  end of function BASH_RestoreOption  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_ScriptCmdLineArguments     {{{1
"   DESCRIPTION:  stringify script command line arguments 
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_ScriptCmdLineArguments ( ... )
	let	b:BASH_ScriptCmdLineArgs	= join( a:000 )
endfunction		" ---------- end of function  BASH_ScriptCmdLineArguments  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_BashCmdLineArguments     {{{1
"   DESCRIPTION:  stringify Bash command line arguments 
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_BashCmdLineArguments ( ... )
	let	b:BASH_BashCmdLineArgs	= join( a:000 )
endfunction    " ----------  end of function BASH_BashCmdLineArguments ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_Run     {{{1
"   DESCRIPTION:  
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
"
let s:BASH_OutputBufferName   = "Bash-Output"
let s:BASH_OutputBufferNumber = -1
"
function! BASH_Run ( mode ) range

	silent exe ':cclose'
"
	let	l:arguments				= exists("b:BASH_ScriptCmdLineArgs") ? " ".b:BASH_ScriptCmdLineArgs : ""
	let	l:currentbuffer   = bufname("%")
	let l:fullname				= expand("%:p")
	let l:fullnameesc			= fnameescape( l:fullname )
	"
	silent exe ":update"
	"
 	if a:firstline != a:lastline
		let tmpfile	= tempname()
		silent exe ':'.a:firstline.','.a:lastline.'write '.tmpfile
	endif
	"
	if a:mode=="v" 
		let tmpfile	= tempname()
		silent exe ":'<,'>write ".tmpfile
	endif

	let l:bashCmdLineArgs	= exists("b:BASH_BashCmdLineArgs") ? ' '.b:BASH_BashCmdLineArgs.' ' : ''
	"
	"------------------------------------------------------------------------------
	"  Run : run from the vim command line (Linux only)     {{{2
	"------------------------------------------------------------------------------
	"
	if s:BASH_OutputGvim == 'vim'
		"
		" ----- visual mode ----------
		"
		if ( a:mode=="v" ) || ( a:firstline != a:lastline )
			exe ":!".s:BASH_BASH.l:bashCmdLineArgs." < ".tmpfile." -s ".l:arguments
			call delete(tmpfile)
			return
		endif
		"
		" ----- normal mode ----------
		"
		call BASH_SaveOption( 'makeprg' )
		exe	":setlocal makeprg=".s:BASH_BASH
		exe	':setlocal errorformat='.s:BASH_Errorformat
		"
		if a:mode=="n"
			exe ":make ".l:bashCmdLineArgs.l:fullnameesc.l:arguments
		endif
		if &term == 'xterm'
			redraw!
		endif
		"
		call BASH_RestoreOption( 'makeprg' )
		exe	":botright cwindow"

		if l:currentbuffer != bufname("%") && a:mode=="n"
			let	pattern	= '^||.*\n\?'
			setlocal modifiable
			" remove the regular script output (appears as comment)
			if search(pattern) != 0
				silent exe ':%s/'.pattern.'//'
			endif
			" read the buffer back to have it parsed and used as the new error list
			silent exe ':cgetbuffer'
			setlocal nomodifiable
			silent exe	':cc'
		endif
		"
		exe	':setlocal errorformat='
	endif
	"
	"------------------------------------------------------------------------------
	"  Run : redirect output to an output buffer     {{{2
	"------------------------------------------------------------------------------
	if s:BASH_OutputGvim == 'buffer'

		let	l:currentbuffernr = bufnr("%")

		if l:currentbuffer ==  bufname("%")
			"
			if bufloaded(s:BASH_OutputBufferName) != 0 && bufwinnr(s:BASH_OutputBufferNumber)!=-1
				exe bufwinnr(s:BASH_OutputBufferNumber) . "wincmd w"
				" buffer number may have changed, e.g. after a 'save as'
				if bufnr("%") != s:BASH_OutputBufferNumber
					let s:BASH_OutputBufferNumber	= bufnr(s:BASH_OutputBufferName)
					exe ":bn ".s:BASH_OutputBufferNumber
				endif
			else
				silent exe ":new ".s:BASH_OutputBufferName
				let s:BASH_OutputBufferNumber=bufnr("%")
				setlocal noswapfile
				setlocal buftype=nofile
				setlocal syntax=none
				setlocal bufhidden=delete
				setlocal tabstop=8
			endif
			"
			" run script
			"
			setlocal	modifiable
			if a:mode=="n"
				if	s:MSWIN
					silent exe ":%!".s:BASH_BASH.l:bashCmdLineArgs.' "'.l:fullname.'" '.l:arguments
				else
					silent exe ":%!".s:BASH_BASH.l:bashCmdLineArgs." ".l:fullnameesc.l:arguments
				endif
			endif
			"
			if ( a:mode=="v" ) || ( a:firstline != a:lastline )
				silent exe ":%!".s:BASH_BASH.l:bashCmdLineArgs." < ".tmpfile." -s ".l:arguments
			endif
			setlocal	nomodifiable
			"
			" stdout is empty / not empty
			"
			if line("$")==1 && col("$")==1
				silent	exe ":bdelete"
			else
				if winheight(winnr()) >= line("$")
					exe bufwinnr(l:currentbuffernr) . "wincmd w"
				endif
			endif
			"
		endif
	endif
	"
	"------------------------------------------------------------------------------
	"  Run : run in a detached xterm     {{{2
	"------------------------------------------------------------------------------
	if s:BASH_OutputGvim == 'xterm'
		"
		if	s:MSWIN
			exe ':!'.s:BASH_BASH.l:bashCmdLineArgs.' "'.l:fullname.'" '.l:arguments
		else
			if a:mode=='n'
				if a:firstline != a:lastline
					let titlestring	= l:fullnameesc.'\ lines\ \ '.a:firstline.'\ -\ '.a:lastline
					silent exe ':!xterm -title '.titlestring.' '.s:BASH_XtermDefaults
								\			.' -e '.s:BASH_Wrapper.' '.l:bashCmdLineArgs.tmpfile.l:arguments.' &'
				else
					silent exe '!xterm -title '.l:fullnameesc.' '.s:BASH_XtermDefaults
								\			.' -e '.s:BASH_Wrapper.' '.l:bashCmdLineArgs.l:fullnameesc.l:arguments.' &'
				endif
			elseif a:mode=="v"
				let titlestring	= l:fullnameesc.'\ lines\ \ '.line("'<").'\ -\ '.line("'>")
				silent exe ':!xterm -title '.titlestring.' '.s:BASH_XtermDefaults
							\			.' -e '.s:BASH_Wrapper.' '.l:bashCmdLineArgs.tmpfile.l:arguments.' &'
			endif
		endif
		"
	endif
	"
	if !has("gui_running") &&  v:progname != 'vim'
		redraw!
	endif
endfunction    " ----------  end of function BASH_Run  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_SyntaxCheck     {{{1
"   DESCRIPTION:  run syntax check
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_SyntaxCheck ()
	exe	":cclose"
	let	l:currentbuffer=bufname("%")
	exe	":update"
	call BASH_SaveOption( 'makeprg' )
	exe	":setlocal makeprg=".s:BASH_BASH
	let l:fullname				= expand("%:p")
	"
	" check global syntax check options / reset in case of an error
	if BASH_SyntaxCheckOptions( s:BASH_SyntaxCheckOptionsGlob ) != 0
		let s:BASH_SyntaxCheckOptionsGlob	= ""
	endif
	"
	let	options=s:BASH_SyntaxCheckOptionsGlob
	if exists("b:BASH_SyntaxCheckOptionsLocal")
		let	options=options." ".b:BASH_SyntaxCheckOptionsLocal
	endif
	"
	" match the Bash error messages (quickfix commands)
	" errorformat will be reset by function BASH_Handle()
	" ignore any lines that didn't match one of the patterns
	"
	exe	':setlocal errorformat='.s:BASH_Errorformat
	silent exe ":make! -n ".options.' -- "'.l:fullname.'"'
	exe	":botright cwindow"
	exe	':setlocal errorformat='
	call BASH_RestoreOption('makeprg')
	"
	" message in case of success
	"
	redraw!
	if l:currentbuffer ==  bufname("%")
		echohl Search | echo l:currentbuffer." : Syntax is OK" | echohl None
		nohlsearch						" delete unwanted highlighting (Vim bug?)
	endif
endfunction		" ---------- end of function  BASH_SyntaxCheck  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_Debugger     {{{1
"   DESCRIPTION:  run debugger
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_Debugger ()
	if !executable(s:BASH_bashdb)
		echohl Search
		echo   s:BASH_bashdb' is not executable or not installed! '
		echohl None
		return
	endif
	"
	silent exe	":update"
	let	l:arguments	= exists("b:BASH_ScriptCmdLineArgs") ? " ".b:BASH_ScriptCmdLineArgs : ""
	let	Sou					= fnameescape( expand("%:p") )
	"
	"
	if has("gui_running") || &term == "xterm"
		"
		" debugger is ' bashdb'
		"
		if s:BASH_Debugger == "term"
			let dbcommand	= "!xterm ".s:BASH_XtermDefaults.' -e '.s:BASH_bashdb.' -- '.Sou.l:arguments.' &'
			silent exe dbcommand
		endif
		"
		" debugger is 'ddd'
		"
		if s:BASH_Debugger == "ddd"
			if !executable("ddd")
				echohl WarningMsg
				echo "The debugger 'ddd' does not exist or is not executable!"
				echohl None
				return
			else
				silent exe '!ddd --debugger '.s:BASH_bashdb.' '.Sou.l:arguments.' &'
			endif
		endif
	else
		" no GUI : debugger is ' bashdb'
		silent exe '!'.s:BASH_bashdb.' -- '.Sou.l:arguments
	endif
endfunction		" ---------- end of function  BASH_Debugger  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  BASH_MakeScriptExecutable     {{{1
"   DESCRIPTION:  make script executable
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! BASH_MakeScriptExecutable ()
  let filename  = fnameescape( expand("%:p") )
	if &filetype != 'sh'
		echo '"'.filename.'" not Bash script.'
		return
	endif
  if executable(filename) == 0 
    silent exe "!chmod u+x ".filename
    redraw!
    if v:shell_error
      echohl WarningMsg
      echo 'Could not make "'.filename.'" executable !'
    else
      echohl Search
      echo 'Made "'.filename.'" executable.'
    endif
    echohl None
	else
		echo '"'.filename.'" is already executable.'
  endif
endfunction   " ---------- end of function  BASH_MakeScriptExecutable  ----------

"----------------------------------------------------------------------
"  *** SETUP PLUGIN *** {{{1
"----------------------------------------------------------------------

call BASH_ToolMenu()

if s:BASH_LoadMenus == 'yes' && s:BASH_CreateMenusDelayed == 'no'
	call BASH_CreateGuiMenus()
endif
"
if has( 'autocmd' )
	"
	"-------------------------------------------------------------------------------
	" shell files with extensions other than 'sh'
	"-------------------------------------------------------------------------------
	if exists( 'g:BASH_AlsoBash' )
		for item in g:BASH_AlsoBash
			exe "autocmd BufNewFile,BufRead  ".item." set filetype=sh"
		endfor
	endif
	"
	"-------------------------------------------------------------------------------
	" create menues and maps
	"-------------------------------------------------------------------------------
  autocmd FileType *
        \ if &filetype == 'sh' |
        \   if ! exists( 'g:BASH_Templates' ) |
        \     if s:BASH_LoadMenus == 'yes' | call BASH_CreateGuiMenus ()        |
        \     else                         | call g:BASH_RereadTemplates ('no') |
        \     endif |
        \   endif |
        \   call s:CreateAdditionalMaps () |
        \   call mmtemplates#core#CreateMaps ( 'g:BASH_Templates', g:BASH_MapLeader, 'do_special_maps' ) |
        \ endif

	"-------------------------------------------------------------------------------
	" insert file header
	"-------------------------------------------------------------------------------
	if s:BASH_InsertFileHeader == 'yes'
		autocmd BufNewFile  *.sh  call mmtemplates#core#InsertTemplate(g:BASH_Templates, 'Comments.file header')
		if exists( 'g:BASH_AlsoBash' )
			for item in g:BASH_AlsoBash
				exe "autocmd BufNewFile ".item." call mmtemplates#core#InsertTemplate(g:BASH_Templates, 'Comments.file header')"
			endfor
		endif
	endif

endif
" }}}1
"
" =====================================================================================
" vim: tabstop=2 shiftwidth=2 foldmethod=marker
