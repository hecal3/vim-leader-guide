let s:save_cpo = &cpo
set cpo&vim

let s:displaynames = {'<C-I>': '<Tab>',
					\ '<C-H>': '<BS>'}

function! leaderGuide#register_prefix_descriptions(key, dictname)
    let key = a:key == '<Space>' ? ' ' : a:key
	if !exists('s:desc_lookup')
		call s:create_cache()
	endif
	if !has_key(s:desc_lookup, key)
		let s:desc_lookup[key] = a:dictname
	endif
endfunction

function! leaderGuide#populate_dictionary(key, dictname)
	call s:start_parser(a:key, s:cached_dicts[a:key])
endfunction

function! leaderGuide#parseMappings()
	for [k, v] in items(s:cached_dicts)
		call s:start_parser(k, v)
	endfor
endfunction

function! leaderGuide#start_by_prefix(vis, key)
	let s:vis = a:vis

	if !has_key(s:cached_dicts, a:key) || g:leaderGuide_run_map_on_popup
		"first run
		let s:cached_dicts[a:key] = {}
		call s:start_parser(a:key, s:cached_dicts[a:key])
	endif
	
	if has_key(s:desc_lookup, a:key)
		let rundict = s:create_target_dict(a:key)
	else
		let rundict = s:cached_dicts[a:key]
	endif
	
    call s:start_guide(rundict)
endfunction

function! leaderGuide#start(vis, dict)
	let s:vis = a:vis
	call s:start_guide(a:dict)
endfunction

function! s:create_cache()
	let s:desc_lookup = {}
	let s:cached_dicts = {}
endfunction

function! s:start_parser(key, dict)
    let key = a:key ==? ' ' ? "<Space>" : a:key
	let readmap = ""
	redir => readmap
	silent execute 'map '.key
	redir END
	let lines = split(readmap, "\n")

	for line in lines
	    let sp = split(line, ' ', 1)
		let k = sp[2] != '' ? sp[2] : sp[3]
	    let mapd = maparg(k, sp[0], 0, 1)
		if mapd.lhs =~ '<Plug>.*'
		    continue
        endif
		let display = mapd.rhs
        let mapd.lhs = substitute(mapd.lhs, key, "", "")
		let mapd.lhs = substitute(mapd.lhs, "<Space>", " ", "g")
		let mapd.lhs = substitute(mapd.lhs, "<Tab>", "<C-I>", "g")
		let mapd.rhs = substitute(mapd.rhs, "<Space>", "<lt>Space>", "g")
		let mapd.rhs = substitute(mapd.rhs, "<SID>", "<SNR>".mapd['sid']."_", "g")
		"let display = substitute(display, "^[:| ]*", "", "")
		let display = substitute(display, "<cr>$", "", "")
		let display = substitute(display, "<CR>$", "", "")
		if mapd.lhs != '' && display !~ 'LeaderGuide.*'
			if (s:vis && match(mapd.mode, "[vx ]") >= 0) ||
						\ (!s:vis && match(mapd.mode, "[vx]") == -1)
			call s:add_map_to_dict(s:string_to_keys(mapd.lhs), mapd.rhs,
						\display, 0, a:dict, mapd.mode)
			endif
		endif
	endfor
endfunction

function! s:add_map_to_dict(key, cmd, desc, level, dict, mode)
	if len(a:key) > a:level+1
		if !has_key(a:dict, a:key[a:level])
			let a:dict[a:key[a:level]] = { 'name' : '' }
		endif
		call s:add_map_to_dict(a:key, a:cmd, a:desc, a:level + 1,
					\a:dict[a:key[a:level]], a:mode)
	else
		let cmd = s:escape_mappings(a:cmd)
		if !has_key(a:dict, a:key[a:level])
			let a:dict[a:key[a:level]] = [cmd, a:desc]
		endif
	endif
endfunction

function! s:escape_mappings(string)
	let rstring = substitute(a:string, '\', '\\\\', 'g')
	let rstring = substitute(rstring, '<\([^<>]*\)>', '\\<\1>', 'g')
	let rstring = substitute(rstring, '"', '\\"', 'g')
	let rstring = 'call feedkeys("'.rstring.'")'
	return rstring
endfunction

function! s:string_to_keys(input)
	" Avoid special case: <>
	if match(a:input, '<.\+>') != -1
		let retlist = []
		let si = 0
		let go = 1
		while si < len(a:input)
			if go
				call add(retlist, a:input[si])
			else
				let retlist[-1] .= a:input[si]
			endif
			if a:input[si] ==? '<'
				let go = 0
			elseif a:input[si] ==? '>'
				let go = 1
			end
			let si += 1
		endw
		return retlist
	else
		return split(a:input, '\zs')
endfunction

function! s:create_target_dict(key)
	if has_key(s:desc_lookup, a:key)
		let tardict = deepcopy({s:desc_lookup[a:key]})
		let mapdict = s:cached_dicts[a:key]
		call s:merge(tardict, mapdict)
	else
		let tardict = s:cached_dicts[a:key]
	endif
	return tardict
endfunction

function! s:merge(dict_t, dict_o)
	let target = a:dict_t
	let other = a:dict_o
	for k in keys(target)
		if type(target[k]) == type({}) && has_key(other, k)
			if type(other[k]) == type({})
				if has_key(target[k], 'name')
					let other[k].name = target[k].name
				endif
				call s:merge(target[k], other[k])
			elseif type(other[k]) == type([])
				let target[k.'m'] = target[k]
				let target[k] = other[k]
			endif
		endif
	endfor
	call extend(target, other, "keep")
endfunction

function! s:calc_layout(dkmap)
	" calculate max entry length
	let length = values(map(filter(copy(a:dkmap), 'v:key != "name"'), 
                \ 'strdisplaywidth("[".v:key."]".'.
                \ '(type(v:val) == type({}) ? v:val["name"] : v:val[1]))'))
	let maxlength = max(length) + g:leaderGuide_vspace
	let cols = winwidth(0) / maxlength
	let colwidth = winwidth(0) / cols
	return [cols, colwidth, maxlength]
endfunction

function! s:escape_keys(inp)
	return substitute(a:inp, "<", "<lt>", "")
endfunction

function! s:show_displayname(inp)
	if has_key(s:displaynames, toupper(a:inp))
		return s:displaynames[toupper(a:inp)]
	else
		return a:inp
	end
endfunction

function! s:create_string(dkmap, ncols, colwidth)
	let output = []
	let colnum = 1
	let nrows = 1
	for k in sort(filter(keys(a:dkmap), 'v:val != "name"'),'1')
		let desc = type(a:dkmap[k]) == type({}) ? a:dkmap[k].name : a:dkmap[k][1]
        let displaystring = "[".s:show_displayname(k)."] ".desc

        call add(output, displaystring)
		if colnum ==? a:ncols || g:leaderGuide_vertical
			call add(output, "\n")
			let nrows += 1
			let colnum = 1
		else
			let colnum += 1
            call add(output, repeat(' ', a:colwidth - strdisplaywidth(displaystring)))
		endif
        execute "cnoremap <nowait> <buffer> " . k . " " . s:escape_keys(k) ."<CR>"
        "let cmd = "cnoremap <nowait> <buffer> " . k . " " . k ."<CR>"
	endfor
	cmap <nowait> <buffer> <Space> <Space><CR>
	return [output, nrows]
endfunction

function! s:start_buffer(lmap)
    call s:winopen()
	let [ncols, colwidth, maxlen] = s:calc_layout(a:lmap)
	let [string, nrows] = s:create_string(a:lmap, ncols, colwidth)

    setlocal modifiable
	if g:leaderGuide_vertical
		execute 'vert res '.maxlen
	else
		execute 'res '.nrows
	endif

	execute "normal! i ".join(string,'')
	setlocal nomodifiable nolist
    redraw
	let inp = input("")
    if inp != '' && inp!= "<lt>ESC>"
		let fsel = get(a:lmap, inp)
	else
		let fsel = ['call feedkeys("\<ESC>")']
	endif
    call s:winclose()
	execute s:winnr.'wincmd w'
	call winrestview(s:winv)
	if type(fsel) ==? type({})
		call s:start_buffer(fsel)
	else
		redraw
		if s:vis
			normal! gv
		endif
        try
            echo fsel[0]
            execute fsel[0]
        catch
            echom v:exception
        endtry
	endif
endfunction

function! s:winopen()
    if !exists('s:bufnr')
        let s:bufnr = -1
    endif
    let pos = g:leaderGuide_position == 'topleft' ? 'topleft' : 'botright'
    if bufexists(s:bufnr)
        let qfbuf = &buftype == 'quickfix'
        let splitcmd = g:leaderGuide_vertical ? ' 1vs' : ' 1sp'
        execute pos.splitcmd
        let bnum = bufnr('%')
        execute	'buffer '.s:bufnr
        cmapclear <buffer>
        if qfbuf
            execute bnum.'bwipeout!'
        endif
    else
        let splitcmd = g:leaderGuide_vertical ? ' 1vnew' : ' 1new'
        execute pos.splitcmd
        let s:bufnr = bufnr('%')
        nnoremap <buffer> <silent> <ESC> call s:winclose()<CR>
        autocmd WinLeave <buffer> call s:winclose()
    endif
    let s:gwin = winnr()
    setlocal filetype=leaderGuide nonumber nowrap
    setlocal nobuflisted buftype=nofile bufhidden=unload noswapfile
endfunction

function! s:winclose()
    if s:gwin == winnr()
        close
        exe s:winres
        let s:gwin = -1
    endif
endfunction

function! s:start_guide(mappings)
	let s:winv = winsaveview()
	let s:winnr = winnr()
	let s:winres = winrestcmd()

	if g:leaderGuide_use_buffer
		call s:start_buffer(a:mappings)
	else
		call s:start_cmdwin(a:mappings)
	endif
endfunction

function! s:start_cmdwin(lmap)
	let [ncols, colwidth, maxlen] = s:calc_layout(a:lmap)
	let [string, nrows] = s:create_string(a:lmap, ncols, colwidth)
    let inp = input('Insert Key: '."\n".join(string,'')."\n")
    let fsel = inp != '' ? get(a:lmap, inp)[0] : ''

	silent! call s:unmap_keys(keys(a:lmap))
	redraw
	execute fsel
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
