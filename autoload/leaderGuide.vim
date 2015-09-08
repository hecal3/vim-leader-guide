function! leaderGuide#Calc_layout(dkmap)
	let maxlength = 0
	for [k, v] in items(a:dkmap)
		let currlen = strdisplaywidth("[".k."] ".v[1]."\t\t")
		if currlen > maxlength
			let maxlength = currlen
		endif
	endfor
	let cols = winwidth(0) / maxlength
	let colwidth = winwidth(0) / cols
	return [cols, colwidth, maxlength]
endfunction

function! leaderGuide#Escape_keys(inp)
	return substitute(a:inp, "<", "<lt>", "")
endfunction

function! leaderGuide#Create_string(dkmap, ncols, colwidth)
	let output = []
	let colnum = 1
	let nrows = 1
	for [k, v] in sort(items(a:dkmap),'i')
		let displaystring = "[".k."] ".v[1]
		let entry_len = strdisplaywidth(displaystring)
        call add(output, displaystring)
		if colnum == a:ncols || g:leaderGuide_vertical
			call add(output, "\n")
			let nrows += 1
			let colnum = 1
		else
			let colnum += 1
			while entry_len < a:colwidth
				call add(output, ' ')
				let entry_len += 1
			endwhile
		endif
		execute "cmap <buffer> " . k . " " . leaderGuide#Escape_keys(k) ."<CR>"
	endfor
	cmap <buffer> <Space> <Space><CR>
	return [output, nrows]
endfunction

function! leaderGuide#Start_cmdwin(lmap)
	let [ncols, colwidth, maxlen] = leaderGuide#Calc_layout(a:lmap)
	let [string, nrows] = leaderGuide#Create_string(a:lmap, ncols, colwidth)
    let inp = input('Insert Key: '."\n".join(string,'')."\n")
    if inp != ''
		let fsel = get(a:lmap, inp)[0]
	else
		let fsel = ''
	endif
	silent! call leaderGuide#Umap_keys(keys(a:lmap))
	redraw
	execute fsel
endfunction

function! leaderGuide#Umap_keys(maplist)
	for k in a:maplist
		execute 'cunmap <buffer>'.k
	endfor
	cunmap <buffer> <Space>
endfunction

function! leaderGuide#Start_buffer(lmap)
	call leaderGuide#Create_buffer()
	let [ncols, colwidth, maxlen] = leaderGuide#Calc_layout(a:lmap)
	let [string, nrows] = leaderGuide#Create_string(a:lmap, ncols, colwidth)

	if g:leaderGuide_vertical
		execute 'vert res '.maxlen
	else
		execute 'res '.nrows
	endif

	execute "normal! i ".join(string,'')
	redraw
	let inp = input("")
    if inp != '' && inp!= "<lt>ESC>"
		let fsel = get(a:lmap, inp)[0]
	else
		let fsel = 'call feedkeys("\<ESC>")'
	endif
	silent! call leaderGuide#Umap_keys(keys(a:lmap))
	bdelete!
	execute s:winnr.'wincmd w'
	call winrestview(s:winv)
	if s:range
		normal gv
	endif
	redraw
	if s:range
		execute s:firstline.','.s:lastline.fsel
	else
		execute fsel
	endif
endfunction


function! leaderGuide#Create_buffer()
	if g:leaderGuide_vertical
		execute g:leaderGuide_position.' 1vnew'
	else
		execute g:leaderGuide_position.' 1new'
	endif
	setlocal filetype=leaderGuide nonumber nowrap
	setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
	nnoremap <buffer> <silent> <ESC> :bdelete!<cr>
	autocmd WinLeave <buffer> :bdelete!
endfunction

function! leaderGuide#Start(dict) range
	let s:range = a:firstline != a:lastline ? 1 : 0
	let s:firstline = a:firstline
	let s:lastline = a:lastline
	let s:winv = winsaveview()
	let s:winnr = winnr()

	if g:leaderGuide_use_buffer
		call leaderGuide#Start_buffer(a:dict)
	else
		call leaderGuide#Start_cmdwin(a:dict)
	endif
endfunction
