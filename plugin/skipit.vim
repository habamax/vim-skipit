" skipit.vim - Skip text till after ([{<"|'>}])
" Maintainer:   Maxim Kim <habamax@gmail.com>

if exists("g:loaded_skipit") || &cp || v:version < 700
	finish
endif
let g:loaded_skipit = 1

fun! s:skipit()
	let pos = searchpos('\v[{([<"''|>\])}]', 'ecW')
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
