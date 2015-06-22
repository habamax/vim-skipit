" skipit.vim - Skip text till after ([{<"|'>}])
" Maintainer:   Maxim Kim <habamax@gmail.com>

if exists("g:loaded_skipit") || &cp || v:version < 700
	finish
endif
let g:loaded_skipit = 1

if !exists('g:skipit_multiline')
	let g:skipit_multiline = 1
endif

fun! s:skipit()
	if(g:skipit_multiline)
		let pos = searchpos('\v[{([<"''|>\])}]', 'ecW')
	else
		let pos = searchpos('\v[{([<"''|>\])}]', 'ec', line('.'))
	endif

	if pos != [0, 0]
		call setpos('.', [0, pos[0], pos[1]+1, 0])
	else
		call setpos('.', [0, line('.'), col('$')])
	endif
endfun

inoremap <silent> <Plug>SkipIt <C-\><C-O>:call <SID>skipit()<CR>

if !hasmapto('<Plug>SkipIt') && maparg('<C-l>','i') ==# ''
	imap <C-l> <Plug>SkipIt
endif
