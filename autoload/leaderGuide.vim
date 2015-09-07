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

function! leaderGuide#Map_them_all(dkmap)
	for [k, v] in items(a:dkmap)
		if has_key(v, '1')
			let ausg = "" . k . "->" .v[1]
		else
			call leaderGuide#Map_them_all(a:dkmap.g)
		endif
	endfor
endfunction

function! leaderGuide#Create_string(dkmap, coldat)
	let output = []
	let colnum = 1
	let nrows = 1
	for [k, v] in sort(items(a:dkmap),'i')
		let displaystring = "[".k."] ".v[1]
		let entry_len = strdisplaywidth(displaystring)
        call add(output, displaystring)
		if colnum == a:coldat[0] || g:leaderGuide_vertical
			call add(output, "\n")
			let nrows += 1
			let colnum = 1
		else
			let colnum += 1
			while entry_len < a:coldat[1]
				call add(output, ' ')
				let entry_len += 1
			endwhile
		endif
		execute "cmap " . k . " " . leaderGuide#Escape_keys(k) ."<CR>"
	endfor
	return [output, nrows]
endfunction

function! leaderGuide#Start_cmdwin(dkmap)
    let output = leaderGuide#Create_string(a:dkmap)
    let inp = input('Insert Key: '."\n".join(output[0],'')."\n")
    if inp != ''
		let fsel = get(a:dkmap, inp)[0]
	else
		let fsel = ''
	endif
	cmapclear
	redraw
	execute fsel
endfunction

function! leaderGuide#Umap_keys(maplist)
	for k in a:maplist
		execute 'cunmap '.k
	endfor
endfunction

function! leaderGuide#Start_buffer(lmap)
	call leaderGuide#Create_buffer()
	let layout = leaderGuide#Calc_layout(a:lmap)
	let output = leaderGuide#Create_string(a:lmap, layout)

	if g:leaderGuide_vertical
		execute 'vert res '.layout[2]
	else
		execute 'res '.output[1]
	endif

	execute "normal! i ".join(output[0],'')
	redraw
	let inp = input("")
    if inp != '' && inp!= "<lt>ESC>"
		let fsel = get(a:lmap, inp)[0]
	else
		let fsel = 'call feedkeys("\<ESC>")'
	endif
	call leaderGuide#Umap_keys(keys(a:lmap))
	:bdelete!
	redraw
	execute fsel
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

function! leaderGuide#Start(dict)
	if g:leaderGuide_use_buffer
		call leaderGuide#Start_buffer(a:dict)
	else
		call leaderGuide#Start_cmdwin(a:dict)
	endif
endfunction
