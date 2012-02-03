" CamelCaseComplete.vim: Insert mode completion that expands CamelCaseWords and
" underscore_words based on anchor characters for each word fragment. 
"
" DEPENDENCIES:
"   - CompleteHelper.vim autoload script. 
"
" Copyright: (C) 2009-2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"   1.00.015	19-Jan-2012	ENH: Handle 'smartcase', as this doesn't work by
"				itself. 
"	014	18-Jan-2012	ENH: Add
"				g:CamelCaseComplete_CaseInsensitiveFallback:
"				When the completion base is all-lowercase, try
"				strict-noic -> strict-ic -> relaxed-noic ->
"				relaxed-ic fallback. 
"	013	11-Dec-2011	Split off functions into separate autoload
"				script. 
"	012	09-Dec-2011	ENH: Try to weed out many corner case bugs,
"				especially when non-alphabetic keyword
"				characters are included. 
"				Strip the 0 and 1-anchor cases out of
"				s:BuildAlphabeticRegexpFragments() into
"				s:BuildAnyMatchFragment() and
"				s:BuildSingleAlphabeticAnchorFragment(). 
"				Change the overall algorithm so that only
"				sequences of alphabetic anchors are converted
"				into a regexp, not the complete set. Consider
"				corner cases of start of the alphabetic
"				sequence and a new alphabetic sequence after a
"				keyword fragment. 
"				New test CamelKeyword001.vim covers all
"				combinations; I hope this proves helpful in
"				practice. I'm afraid the regexp generation has
"				started a life of its own, and I hope I never
"				have to look into it again :-(  
"	011	07-Dec-2011	CHG: Do a default match for the anchor of
"				the first CamelCase fragment, not always a
"				case-insensitive match. This way, with
"				'noignorecase', "acw" will only match
"				"aCamelWord" and "Tcw"will only match
"				"TheCamelWord".  
"	010	02-Nov-2011	FIX: Do not clobber unnamed register when
"				removing base keys. 
"	009	30-Sep-2011	Use <silent> for <Plug> mapping instead of
"				default mapping. 
"	008	26-Feb-2010	Moved s:BuildRegexp() from "findstart" to "base"
"				invocation, so that the script-scoped
"				strictRegexp and relaxedRegexp become local
"				variables. It doesn't matter when this is
"				invoked; if the base becomes smaller (due to the
"				user undoing the completion via CTRL-E or by
"				repeating <BS>), Vim will re-invoke both modes,
"				anyway. 
"	007	12-Jan-2010	Now setting g:CamelCaseComplete_FindStartMark by
"				default, and considering the limited
"				availability of the '" mark. 
"				Found out that the plugin doesn't work on Vim
"				7.0; updated version guard. 
"	006	07-Aug-2009	Using a map-expr instead of i_CTRL-O to set
"				'completefunc', as the temporary leave of insert
"				mode caused a later repeat via '.' to only
"				insert the completed fragment, not the entire
"				inserted text.  
"	005	18-Jun-2009	Implemented optional setting of a mark at the
"				findstart position. If this is done, the
"				completion base is automatically removed if no
"				matches were found: As the base just consists of
"				a sequence of anchor characters, it isn't
"				helpful for further editing when the completion
"				failed. 
"	004	11-Jun-2009	Implemented keyword (i.e. non-alphabetic)
"				anchors. 
"				BF: Strict underscore_word fragments swallowed
"				CamelCaseWords. 
"	003	10-Jun-2009	BF: ACRONYMs inside CamelCaseWords are now
"				included in strict matches, not relaxed. 
"				BF: Relaxed CamelCase match does not match
"				anchor inside ACRONYMS, only at the beginning of
"				a fragment. 
"				BF: Anchor must not match inside ACRONYM, so
"				check that characters following the strict
"				CamelCase fragment do not belong to the same
"				ACRONYM. 
"	002	09-Jun-2009	BF: First relaxed CamelCase fragment must not
"				swallow underscores. 
"	001	08-Jun-2009	file creation

let s:save_cpo = &cpo
set cpo&vim

function! s:GetCompleteOption()
    return (exists('b:CamelCaseComplete_complete') ? b:CamelCaseComplete_complete : g:CamelCaseComplete_complete)
endfunction

function! s:ToCamelCaseAnchor( anchor )
    return '\%(' . toupper(a:anchor) . '\&\u\|\%(\k\&\A\)\+' . a:anchor . '\)'
endfunction
function! s:BuildAnyMatchFragment()
    " Without any anchors, build a regexp that matches any CamelCaseWord or
    " underscore_word. 
    let l:anyFragmentRegexp = 
    \   '\%(' .
    \	'\k\*\%(_\@!\k\&\U\)\k\*\u\k\+' .
    \   '\|' .
    \	'_\*\k\*\%(_\@!\k\)_\+\%(_\@!\k\)\%(\k\|_\)\*' .
    \   '\)'
    return [l:anyFragmentRegexp, l:anyFragmentRegexp]
endfunction
function! s:BuildSingleAlphabeticAnchorFragment( isAfterKeywordFragment, anchor )
    " With just one anchor, build a regexp that matches any CamelCaseWord or
    " underscore_word starting with the anchor (possibly preceded by leading
    " underscore(s)). 
    let l:singleAnchorFragmentRegexp = 
    \   '\%(' .
    \	(a:isAfterKeywordFragment ?
    \	    '\%(\%(_\@!\k\&\A\)\@<=' . a:anchor . '\|\l\+' . s:ToCamelCaseAnchor(a:anchor) . '\)' . '\%(_\@!\k\)\*_\@!' :
    \	    a:anchor . '\%(_\@!\k\)\*\%(_\@!\k\&\U\)\%(_\@!\k\)\*\u\k\+'
    \	) .
    \   '\|' .
    \	'_\*' . a:anchor . '\k\*\%(_\@!\k\)_\+\%(_\@!\k\)\%(\k\|_\)\*' .
    \   '\)'
    return [l:singleAnchorFragmentRegexp, l:singleAnchorFragmentRegexp]
endfunction
function! s:BuildAlphabeticRegexpFragments( isStartFragment, isAfterKeywordFragment, anchors )
    " We need at least two anchors in total to be able to build an exact match
    " for CamelCaseWords or underscore_words. 
    if len(a:anchors) < 1 | throw 'ASSERT: Must pass at least one anchor.' | endif
    "
    " The CamelCaseWord may start with either lower or uppercase; each following
    " CamelCase anchor one must match an uppercase character, except when it is
    " preceded by non-alphabetic keyword characters. I.e. we recognize in
    " camelWord#isHere the fragments "c", "W", "i" and "H". 
    " Note: We cannot simply use toupper(); 'ignorecase' may suspend this
    " distinction. We also cannot force case sensitivity via /\C/, because that
    " would apply to the entire pattern and thus also to the underscore_words. 
    let l:camelCaseAnchors = 
    \	map(copy(a:anchors), 's:ToCamelCaseAnchor(v:val)')

    " A strict CamelCase fragment consists of the CamelCase anchor followed by
    " non-uppercase keyword characters without '_', or the uppercase anchor
    " followed by a sequence of uppercase characters (to handle ACRONYMS); this
    " must not be followed by two (or more) uppercase characters, or the ACRONYM
    " would not yet have ended. (One following uppercase character is okay, as
    " long as the keyword doesn't end there, it is then the beginning of the
    " next CamelCase fragment.)
    " To match, the first fragment must not be followed by 
    " a) an underscore character; otherwise, this would make the match at the
    "    beginning of a underscore_word always case insensitive.
    " b) a lowercase character; the match would stop in the middle of a fragment
    "    and thus introduce a phantom fragment which could match a strict
    "    underscore_word fragment. 
    let l:camelCaseStrictFragments =
    \	['\%(' . a:anchors[0] . '\%(_\@!\k\&\U\)\+\%(_\|\l\)\@!\|\%(' . toupper(a:anchors[0]) . '\&\u\)\u\+\%(\u\u\|\u\>\)\@!\)'] +
    \	map(l:camelCaseAnchors[1:], 'v:val . ''\%(\%(_\@!\k\&\U\)\+\|\u\+\%(\u\u\|\u\>\)\@!\)''')

    " A relaxed CamelCase fragment can also be followed by uppercase characters
    " and can swallow underscores. No uppercase character must precede this
    " fragment or the anchor must be followed by a lowercase character to avoid
    " that anything inside an ACRONYM matches.
    " To match, the first fragment must not contain underscores and not be
    " followed by an underscore character; otherwise, this would make the match
    " at the beginning of a underscore_word always case insensitive.
    let l:camelCaseRelaxedFragments =
    \	[
    \	    (a:isStartFragment ?
    \		a:anchors[0] :
    \		(a:isAfterKeywordFragment ?
    \		    '\%(\%(_\@!\k\&\A\)\@<=' . a:anchors[0] . '\|\l\+' . s:ToCamelCaseAnchor(a:anchors[0]) . '\)' :
    \		    '_\@<!' . l:camelCaseAnchors[0])
    \	    ) . '\%(_\@!\k\)\*_\@!'
    \	] +
    \	map(l:camelCaseAnchors[1:], '''\%(\%(_\@!\U\)\@<='' . v:val . ''\k\*\|_\@<!'' . v:val . ''\l\k\*\)''')

    " A strict underscore_word fragment consists of either
    " a) the anchor preceded by underscore(s) (except for the first fragment,
    "    where any preceding underscore(s) are optional), followed by keyword
    "    characters without '_' that do not contain a CamelCaseWord. 
    " b) the anchor followed by keyword characters without '_' that do not
    "    contain a CamelCaseWord. After that, a second underscore_word fragment
    "    must start (i.e. an after-match of '_'), to ensure that the fragment is
    "    actually part of an underscore_word. 
    " To avoid matching a CamelCaseWord, the keywords without '_' must not
    " contain an uppercase character when there were lowercase characters
    " before, so (in negation) they must be either non-lowercase characters
    " optionally followed by lowercase characters, or all non-uppercase
    " characters. 
    "	Regexp: \%(_\@!\k\&\L\)\+\%(_\@!\k\&l\)\*\|\%(_\@!\k\&\U\)\+
    " To match, the first fragment must be followed by underscore(s); otherwise,
    " this would swallow arbitrary text at the beginning of a CamelCaseWord. 
    let l:underscoreStrictFragments =
    \	['_\*' . a:anchors[0] . '\%(\%(_\@!\k\&\L\)\+\%(_\@!\k\&l\)\*\|\%(_\@!\k\&\U\)\+\)_\@='] +
    \	map(a:anchors[1:], '''\%(_\+'' . v:val . ''\%(\%(_\@!\k\&\L\)\+\%(_\@!\k\&l\)\*\|\%(_\@!\k\&\U\)\+\)\|'' . v:val . ''\%(\%(_\@!\k\&\L\)\+\%(_\@!\k\&l\)\*\|\%(_\@!\k\&\U\)\+\)_\@=\)''')

    " A relaxed underscore_word fragment can also swallow underscores for which
    " no anchor was provided. 
    let l:underscoreRelaxedFragments =
    \	[
    \	    (a:isAfterKeywordFragment ?
    \		'\%(_\@!\k\&\A\)\@<=' . '_\*' . a:anchors[0] . '\k\+\%(\%(_\|\k\&\A\)\@=\|_\k\+\)\|_\+' . a:anchors[0] . '\k\+' :
    \		'_\*' . a:anchors[0] . '\k\+\%(_\|\k\&\A\)\@='
    \	    )
    \	] +
    \	map(a:anchors[1:], '''_\+'' . v:val . ''\k\+''')

    " Each fragment must match either one part of a CamelCaseWord or
    " underscore_word. This way, combined CamelCase_with_underScoreWords can
    " also be matched. 
    let l:strictRegexpFragments = []
    let l:relaxedRegexpFragments = []
    for l:i in range(len(a:anchors))
	"call add(l:strictRegexpFragments, '\%(' . l:camelCaseStrictFragments[l:i]  . '\)')
	"call add(l:relaxedRegexpFragments, '\%(' . l:camelCaseRelaxedFragments[l:i] . '\)')
	"call add(l:strictRegexpFragments, '\%(' . l:underscoreStrictFragments[l:i]  . '\)')
	"call add(l:relaxedRegexpFragments, '\%(' . l:underscoreRelaxedFragments[l:i] . '\)')
	call add(l:strictRegexpFragments, '\%(' . l:camelCaseStrictFragments[l:i]  . '\|' . l:underscoreStrictFragments[l:i]  . '\)')
	call add(l:relaxedRegexpFragments, '\%(' . l:camelCaseRelaxedFragments[l:i] . '\|' . l:underscoreRelaxedFragments[l:i] . '\)')
    endfor
    return [join(l:strictRegexpFragments, ''), join(l:relaxedRegexpFragments, '')]
endfunction
function! s:BuildKeywordRegexpFragment( anchor )
    " A strict keyword fragment consists of the keyword anchor optionally
    " followed by anything that is not a CamelCase or underscore fragment. 
    let l:strictRegexpFragment = a:anchor . '\%(_\@!\k\&\A\)\*'

    " A relaxed keyword fragment can also be followed by alphabetic characters
    " and can swallow underscores. 
    let l:relaxedRegexpFragment = a:anchor . '\%(_\|\k\)\*'
    
    return [l:strictRegexpFragment, l:relaxedRegexpFragment]
endfunction
function! s:WholeWordMatch( expr )
    return '\V\<' . a:expr . '\>'
endfunction
function! s:IsAlpha( expr )
    return (a:expr =~# '^\a\+$')
endfunction
function! s:BuildRegexp( base )
    " Each alphabetic character is an anchor for the beginning of a
    " CamelCaseWord or underscore_word. 
    " All other (keyword) characters must just match at that position. 
    let l:anchors = map(split(a:base, '\zs'), 'escape(v:val, "\\")')
    let l:totalAlphabeticAnchors = filter(copy(l:anchors), 's:IsAlpha(v:val)')

    " Assemble all regexp fragments together to build the full regexp. 
    " There is a strict regexp which is tried first and a relaxed regexp to fall
    " back on. 
    let l:strictRegexp = ''
    let l:relaxedRegexp = ''
    let l:idx = 0
    let l:alphabeticAnchorSequence = []
    let l:isStartAlphabeticFragment = 1
    let l:isAfterKeywordFragment = 0
    while l:idx < len(l:anchors)
	let l:anchor = l:anchors[l:idx]
	if s:IsAlpha(l:anchor)
	    let l:alphabeticAnchorSequence = [l:anchor]
	    if len(l:totalAlphabeticAnchors) == 1 && l:idx == len(l:anchors) - 1
		" With just one alphabetic anchor at all, build special regexps
		" that match anything resembling CamelCaseWords /
		" underscore_words, unless a keyword anchor still follows. 
		let [l:strictRegexpFragment, l:relaxedRegexpFragment] = s:BuildSingleAlphabeticAnchorFragment(l:isAfterKeywordFragment, l:anchor)
"****D echomsg '####' l:isStartAlphabeticFragment l:isAfterKeywordFragment 's:' . l:anchor
	    else
		" If an anchor is alphabetic, build a regexp fragment from it and
		" all following alphabetic anchors. We cannot just concatenate
		" individual regexp fragments because the regexp is different. 
		while s:IsAlpha(get(l:anchors, l:idx + 1, ''))
		    let l:idx += 1
		    call add(l:alphabeticAnchorSequence, l:anchors[l:idx])
		endwhile
		let [l:strictRegexpFragment, l:relaxedRegexpFragment] =
		\   s:BuildAlphabeticRegexpFragments(l:isStartAlphabeticFragment, l:isAfterKeywordFragment, l:alphabeticAnchorSequence)

"****D echomsg '####' l:isStartAlphabeticFragment l:isAfterKeywordFragment join(l:alphabeticAnchorSequence)
	    endif
	    let l:isStartAlphabeticFragment = 0
	    let l:isAfterKeywordFragment = 0
	else
	    " If an anchor is a keyword character, just match that character. 
	    let [l:strictRegexpFragment, l:relaxedRegexpFragment] = s:BuildKeywordRegexpFragment(l:anchor)
	    let l:alphabeticAnchorSequence = []	" Reset. 
	    let l:isAfterKeywordFragment = 1
"****D echomsg '####' '"'. l:anchor . '"'
	endif

	let l:strictRegexp  .= l:strictRegexpFragment
	let l:relaxedRegexp .= l:relaxedRegexpFragment
	let l:idx += 1
    endwhile

    " Each alphabetic anchor results in one fragment; there still is one
    " fragment to match any CamelCaseWords and underscore_words when there are
    " no alphabetic anchors after the last keyword anchor or at all. 
    if len(l:alphabeticAnchorSequence) == 0
	let [l:strictRegexpFragment, l:relaxedRegexpFragment] = s:BuildAnyMatchFragment()
	let l:strictRegexp  .= l:strictRegexpFragment
	let l:relaxedRegexp .= l:relaxedRegexpFragment
"****D echomsg '#### ...'
    endif

"****D return [s:WholeWordMatch(l:strictRegexp), '']
    " With no keyword anchors and no or only one alphabetic anchor, the relaxed
    " regexp may be identical with the strict one. In this case, omit the
    " relaxed regexp to avoid searching for (no existing) matches twice. 
    return [s:WholeWordMatch(l:strictRegexp), (l:relaxedRegexp ==# l:strictRegexp ? '' : s:WholeWordMatch(l:relaxedRegexp))]
endfunction
function! s:IsSmartCaseFallback( base )
    return g:CamelCaseComplete_CaseInsensitiveFallback && ! &ignorecase && a:base !~# '\u'
endfunction
function! s:FindMatches( matches, regexp, searchDescription, isIgnoreCase)
    if ! empty(a:searchDescription)
	echohl ModeMsg
	echo printf('-- User defined completion (^U^N^P) -- %s %ssearch...', a:searchDescription, (a:isIgnoreCase ? 'case-insensitive ' : ''))
	echohl None
    endif

    if a:isIgnoreCase
	set ignorecase
    endif
    try
	call CompleteHelper#FindMatches( a:matches, a:regexp, {'complete': s:GetCompleteOption()} )
    finally
	if a:isIgnoreCase
	    set noignorecase
	endif
    endtry
endfunction
function! CamelCaseComplete#CamelCaseComplete( findstart, base )
    if a:findstart
	" Locate the start of the keyword that represents the initial letters. 
	let l:startCol = searchpos('\k*\%#', 'bn', line('.'))[1]
	if l:startCol == 0
	    let l:startCol = col('.')
	endif

	if ! empty(g:CamelCaseComplete_FindStartMark)
	    " Record the position of the start of the completion base to allow
	    " removal of the completion base if no matches were found. 
	    let l:findstart = [0, line('.'), l:startCol, 0]
	    call setpos(printf("'%s", g:CamelCaseComplete_FindStartMark), l:findstart)
	endif

	return l:startCol - 1 " Return byte index, not column. 
    else
	let [l:strictRegexp, l:relaxedRegexp] = s:BuildRegexp(a:base)
"****D let [g:sr, g:rr] = [l:strictRegexp, l:relaxedRegexp]
	if empty(l:strictRegexp) | throw 'ASSERT: At least a strict regexp should have been built.' | endif

	let l:matches = []

	if &ignorecase && &smartcase && a:base !~# '\u'
	    " The 'smartcase' setting doesn't work by itself, because the
	    " generated regexps always contain uppercase letters, and therefore
	    " cause Vim to always perform a case-sensitive search. Therefore, we
	    " need to temporarily disable 'smartcase' (so that 'ignorecase'
	    " applies unconditionally) when the condition for 'smartcase'
	    " (i.e. completion base contains uppercase characters) does not
	    " apply. 
	    let l:save_smartcase = &smartcase
	    set nosmartcase
	endif

	" Find keywords matching the prepared regexp. Fall back to a
	" case-insensitive search when there are no matches. Use the relaxed
	" regexp when the strict one doesn't yield any matches, also with the
	" fallback. 
	try
	    call s:FindMatches(l:matches, l:strictRegexp, '', 0)
	    if empty(l:matches) && s:IsSmartCaseFallback(a:base)
		call s:FindMatches(l:matches, l:strictRegexp, 'Strict', 1)
	    endif
	    if empty(l:matches) && ! empty(l:relaxedRegexp)
		call s:FindMatches(l:matches, l:relaxedRegexp, 'Relaxed', 0)
	    endif
	    if empty(l:matches) && ! empty(l:relaxedRegexp) && s:IsSmartCaseFallback(a:base)
		call s:FindMatches(l:matches, l:relaxedRegexp, 'Relaxed', 1)
	    endif
	finally
	    if exists('l:save_smartcase')
		let &smartcase = l:save_smartcase
	    endif
	endtry

	let s:isNoMatches = empty(l:matches)
	return l:matches
    endif
endfunction

function! CamelCaseComplete#RemoveBaseKeys()
    return (s:isNoMatches && ! empty(g:CamelCaseComplete_FindStartMark) ? "\<C-e>\<C-\>\<C-o>\"_dg`" . g:CamelCaseComplete_FindStartMark : '')
endfunction
function! CamelCaseComplete#Expr()
    set completefunc=CamelCaseComplete#CamelCaseComplete
    return "\<C-x>\<C-u>"
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
