" skipit.vim - Skip text till after ([{<"|'>}])
" Maintainer:   Maxim Kim <habamax@gmail.com>

if exists("g:loaded_skipit") || &cp || v:version < 700
	finish
endif
let g:loaded_skipit = 1

if !exists('g:skipit_multiline')
	let g:skipit_multiline = 1
endif

let s:quotes = '"''`|'
let s:beginning_delimiters = '[{(<'
let s:ending_delimiters = '\])}>'

fun! s:skipit()
	let pattern='\v['.s:beginning_delimiters.s:ending_delimiters.s:quotes.']'
	let pos = s:findnext(pattern)

	if pos != [0, 0]
		call setpos('.', [0, pos[0], pos[1]+1, 0])
	else
		call setpos('.', [0, line('.'), col('$')])
	endif
endfun

fun! s:skipitback()
	let pattern='\v['.s:beginning_delimiters.s:ending_delimiters.s:quotes.']'
	let pos = s:findprev(pattern)

	if pos != [0, 0]
		call setpos('.', [0, pos[0], pos[1], 0])
	else
		call setpos('.', [0, line('.'), 0])
	endif
endfun

fun! s:skipall()
	let pattern = '\v['.s:beginning_delimiters.s:ending_delimiters.']'
	let pos = s:findnext(pattern)

	if pos != [0, 0]
		" Keep looking forward and find the true stop position
		" First find out if we found a beginning delimiter or an ending
		" delimiter, and keep looking for the same type of delimiter
		let delimiters=''
		if(s:isin(s:getcharat(pos), s:beginning_delimiters))
			let delimiters .= s:beginning_delimiters
		else
			let delimiters .= s:ending_delimiters
		endif
		
		" All ignorable delimeters
		let all_delimiters = delimiters.s:quotes."\s\t\n"
		" Initialize the position for iterating the current buffer
		let curlinepos=pos[0]
		let curpos=pos[1]
		let lastlinepos=line('$')
		let stop=0
		while (curlinepos <= lastlinepos && !stop)
			let curline=getline(curlinepos)
			while (curpos <= len(curline) && !stop)
				let curchar=s:getcharat([curlinepos, curpos])
				if(s:isin(curchar, all_delimiters))
					if(s:isin(curchar, delimiters))
						let pos=[curlinepos, curpos+1]
					endif
					let curpos=curpos+1
				else
					let stop=1
				endif
			endwhile
			let curlinepos=curlinepos+1
			let curpos=1
		endwhile
		call setpos('.', [0, pos[0], pos[1], 0])
	else
		call setpos('.', [0, line('.'), col('$')])
	endif
endfun

fun! s:skipallback()
	let pattern = '\v['.s:beginning_delimiters.s:ending_delimiters.']'
	let pos = s:findprev(pattern)

	if pos != [0, 0]
		" Keep looking forward and find the true stop position
		" First find out if we found a beginning delimiter or an ending
		" delimiter, and keep looking for the same type of delimiter
		let delimiters=''
		if(s:isin(s:getcharat(pos), s:beginning_delimiters))
			let delimiters .= s:beginning_delimiters
		else
			let delimiters .= s:ending_delimiters
		endif
		
		" All ignorable delimeters
		let all_delimiters = delimiters.s:quotes."\s\t\n"
		" Initialize the position for iterating the current buffer
		let curlinepos=pos[0]
		let curpos=pos[1]
		let stop=0
		while (curlinepos >=1 && !stop)
			let curline=getline(curlinepos)
			while (curpos >= 1 && !stop)
				let curchar=s:getcharat([curlinepos, curpos])
				if(s:isin(curchar, all_delimiters))
					if(s:isin(curchar, delimiters))
						let pos=[curlinepos, curpos+1]
					endif
					let curpos=curpos-1
				else
					let stop=1
				endif
			endwhile
			let curlinepos=curlinepos-1
			if(curlinepos > 1)
				let curpos=len(getline(curlinepos))
			endif
		endwhile
		call setpos('.', [0, pos[0], pos[1]-1, 0])
	else
		call setpos('.', [0, line('.'), col('$')])
	endif
endfun

fun! s:findnext(pattern)
	if(g:skipit_multiline)
		" c - accept matches at the current cursor
		return searchpos(a:pattern, 'ecW')
	else
		return searchpos(a:pattern, 'ec', line('.'))
	endif
endfun

fun! s:findprev(pattern)
	if(g:skipit_multiline)
		return searchpos(a:pattern, 'beW')
	else
		return searchpos(a:pattern, 'be', line('.'))
	endif
endfun

fun! s:getcharat(pos)
	return getline(a:pos[0])[a:pos[1] - 1]
endfun

fun! s:isin(char, string)
	return stridx(a:string, a:char) >= 0
endfun

inoremap <silent> <Plug>SkipIt <C-\><C-O>:call <SID>skipit()<CR>
inoremap <silent> <Plug>SkipItBack <C-\><C-O>:call <SID>skipitback()<CR>
inoremap <silent> <Plug>SkipAll <C-\><C-O>:call <SID>skipall()<CR>
inoremap <silent> <Plug>SkipAllBack <C-\><C-O>:call <SID>skipallback()<CR>

if !hasmapto('<Plug>SkipIt') && maparg('<C-l>','i') ==# ''
	imap <C-l> <Plug>SkipIt
endif

if !hasmapto('<Plug>SkipItBack') && maparg('<C-b>','i') ==# ''
	imap <C-b> <Plug>SkipItBack
endif

if !hasmapto('<Plug>SkipAll') && maparg('<C-g>l','i') ==# ''
	imap <C-g>l <Plug>SkipAll
endif

if !hasmapto('<Plug>SkipAllBack') && maparg('<C-g>b','i') ==# ''
	imap <C-g>b <Plug>SkipAllBack
endif
