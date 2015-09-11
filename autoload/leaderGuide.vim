fun! s:merge(dict_t, dict_o)
	let target = a:dict_t
	let other = a:dict_o
	for k in keys(target)
		if type(target[k]) == type({}) && has_key(other, k)
			"echom k.' other:'type(other[k])
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
endf

fun! s:create_target_dict(key)
	if has_key(g:desc_lookup, a:key)
		let tardict = deepcopy({g:desc_lookup[a:key]})
		let mapdict = g:cached_dicts[a:key]
		"echo tardict
		"echo mapdict
		call s:merge(tardict, mapdict)
	else
		let tardict = g:cached_dicts[a:key]
	endif
	return tardict
endf

function! s:get_map(cmd)
	let readmap = ""
	redir => readmap
	silent execute a:cmd
	redir END
	let lines = split(readmap, "\n")
	return lines
endfunction

fun! s:create_cache()
	let g:desc_lookup = {}
	let g:cached_dicts = {}
endf

fun! leaderGuide#register_prefix_descriptions(key, dictname)
	if !exists('g:desc_lookup')
		call s:create_cache()
	endif
	if !has_key(g:desc_lookup, a:key)
		let g:desc_lookup[a:key] = a:dictname
	endif
endf

function! leaderGuide#populate_dictionary(key, dictname)
	call s:start_parser(a:key, g:cached_dicts[a:key])
endfunction

fun! leaderGuide#parseMappings()
	for [k, v] in items(g:cached_dicts)
		call s:start_parser(k, v)
	endfor
endf

fun! s:start_parser(key, dict)
	let lines = s:get_map("map ".a:key)
	for line in lines
		"echo line
		let maps = s:handle_line(line)
		let display = maps[3]
		let maps[1] = substitute(maps[1], a:key, "", "")
		let maps[1] = substitute(maps[1], "<Space>", " ", "g")
		let maps[3] = substitute(maps[3], "<Space>", "<lt>Space>", "g")
		let maps[1] = substitute(maps[1], "<Tab>", "<C-I>", "g")
		let maps[3] = substitute(maps[3], "^ *", "", "")
		let display = substitute(display, "^[:| ]*", "", "")
		let display = substitute(display, "<CR>$", "", "")
		"echom join(maps)
		if maps[1] != ''
			if s:vis && match(maps[0], "[vx ]") >= 0
			call s:add_mapping(s:string_to_keys(maps[1]), maps[3],
						\display, 0, a:dict, maps[0])
			elseif !s:vis && match(maps[0], "[vx]") == -1
			call s:add_mapping(s:string_to_keys(maps[1]), maps[3],
						\display, 0, a:dict, maps[0])
			endif
		endif
	endfor
endf

function! s:handle_line(line)
	"echo a:line
	let mlist =
	\matchlist(a:line,'\([xnvco]\{0,3}\) *\([^ ]*\) *\([@&\*]\{0,3}\)\(.*\)$')
	"echo mlist
	return mlist[1:]
endfunction

function! s:add_mapping(key, cmd, desc, level, dict, mode)
	if len(a:key) > a:level+1
		" Go to next level
		if a:level ==? 0
			if !has_key(a:dict, a:key[a:level])
				let a:dict[a:key[a:level]] = { 'name' : '' }
			endif
		elseif a:level ==? 1
			if !has_key(a:dict[a:key[a:level-1]], a:key[a:level])
				let a:dict[a:key[a:level-1]][a:key[a:level]] =
							\{ 'name' : '' }
			endif
		elseif a:level ==? 2
			if !has_key(a:dict[a:key[a:level-2]][a:key[a:level-1]],
						\a:key[a:level])
				let a:dict[a:key[a:level-2]][a:key[a:level-1]]
							\[a:key[a:level]] = { 'name' : '' }
			endif
		endif
		call s:add_mapping(a:key, a:cmd, a:desc, a:level + 1, a:dict, a:mode)
	else
		"echo a:mode."|"
		let thekey = a:key[a:level]
		"if a:mode == "v"
			"echo "visual"
			"let thekey = thekey.'v'
		"endif
		"echo thekey
			
		" This level
		let command = s:escape_mappings(a:cmd)
		if a:level ==? 0
			if !has_key(a:dict, thekey)
				let a:dict[thekey] = [command,  a:desc]
			endif
		elseif a:level ==? 1
			if !has_key(a:dict[a:key[a:level-1]], thekey)
				let a:dict[a:key[a:level-1]][thekey] 
							\= [ command, a:desc ]
			endif
		elseif a:level ==? 2
			if !has_key(a:dict[a:key[a:level-2]][a:key[a:level-1]], 
						\thekey)
				let a:dict[a:key[a:level-2]][a:key[a:level-1]]
							\[thekey] = [ command, a:desc ]
			endif
		elseif a:level ==? 3
			if !has_key(a:dict[a:key[a:level-3]][a:key[a:level-2]]
						\[a:key[a:level-1]], thekey)
				let a:dict[a:key[a:level-3]][a:key[a:level-2]]
							\[a:key[a:level-1]][thekey]
							\ = [ command, a:desc ]
			endif
		endif
	endif
endfunction

function! s:escape_mappings(string)
	let rstring = substitute(a:string, '<\([^<>]*\)>', '\\<\1>', 'g')
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

function! s:calc_layout(dkmap)
	let maxlength = 0
	for k in keys(a:dkmap)
		if k != 'name'
		if type(a:dkmap[k]) == type({})
			let currlen = strdisplaywidth("[".k."] ". a:dkmap[k].name ."\t\t")
		else
			let string = a:dkmap[k]
			let desc = string[1]
			let currlen = strdisplaywidth("[".k."] ".desc."\t\t")
		endif
		if currlen > maxlength
			let maxlength = currlen
		endif
		endif
	endfor
	let cols = winwidth(0) / maxlength
	let colwidth = winwidth(0) / cols
	return [cols, colwidth, maxlength]
endfunction

function! s:escape_keys(inp)
	return substitute(a:inp, "<", "<lt>", "")
endfunction

let s:displaynames = {'<C-I>': '<Tab>',
					\ '<C-H>': '<BS>'}

function! s:show_displayname(inp)
	if has_key(s:displaynames, toupper(a:inp))
		return s:displaynames[toupper(a:inp)]
	else
		return a:inp
	end
endfunction

function! s:create_string(dkmap, ncols, colwidth)
	"echo a:dkmap
	let output = []
	let colnum = 1
	let nrows = 1
	for k in sort(keys(a:dkmap),'i')
		if k != 'name'
		if type(a:dkmap[k]) == type({})
			let displaystring = "[".s:show_displayname(k)."] ".a:dkmap[k].name
		else
			let string = a:dkmap[k]
			let desc = string[1]
			let displaystring = "[".s:show_displayname(k)."] ". desc
		endif
		let entry_len = strdisplaywidth(displaystring)
        call add(output, displaystring)
		if colnum ==? a:ncols || g:leaderGuide_vertical
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
		execute "cmap <nowait> <buffer> " . k . " " . s:escape_keys(k) ."<CR>"
		endif
	endfor
	cmap <nowait> <buffer> <Space> <Space><CR>
	return [output, nrows]
endfunction

function! s:start_cmdwin(lmap)
	let [ncols, colwidth, maxlen] = s:calc_layout(a:lmap)
	let [string, nrows] = s:create_string(a:lmap, ncols, colwidth)
    let inp = input('Insert Key: '."\n".join(string,'')."\n")
    if inp != ''
		let fsel = get(a:lmap, inp)[0]
	else
		let fsel = ''
	endif
	silent! call s:unmap_keys(keys(a:lmap))
	redraw
	execute fsel
endfunction

function! s:start_buffer(lmap)
	call s:create_buffer()
	let [ncols, colwidth, maxlen] = s:calc_layout(a:lmap)
	let [string, nrows] = s:create_string(a:lmap, ncols, colwidth)

	if g:leaderGuide_vertical
		execute 'vert res '.maxlen
	else
		execute 'res '.nrows
	endif

	execute "normal! i ".join(string,'')
	setlocal nomodifiable
	redraw
	let inp = input("")
    if inp != '' && inp!= "<lt>ESC>"
		let fsel = get(a:lmap, inp)
	else
		let fsel = ['call feedkeys("\<ESC>")']
	endif
	bdelete!
	execute s:winnr.'wincmd w'
	call winrestview(s:winv)
	if type(fsel) ==? type({})
		call s:start_buffer(fsel)
	else
		redraw
		if s:vis
			normal gv
		endif
		execute fsel[0]
	endif
endfunction

function! s:create_buffer()
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

fun! s:start_guide(mappings)
	let s:winv = winsaveview()
	let s:winnr = winnr()

	if g:leaderGuide_use_buffer
		call s:start_buffer(a:mappings)
	else
		call s:start_cmdwin(a:mappings)
	endif
endf

fun! leaderGuide#start_by_prefix(vis, key)
	let s:vis = a:vis

	if a:key ==? ' '
		let startkey = "<Space>"
	else
		let startkey = s:escape_keys(a:key)
	endif

	if !has_key(g:cached_dicts, startkey) || g:leaderGuide_run_map_on_popup
		"first run
		let g:cached_dicts[startkey] = {}
		call s:start_parser(startkey, g:cached_dicts[startkey])
	endif
	
	if has_key(g:desc_lookup, startkey)
		let rundict = s:create_target_dict(startkey)
	else
		let rundict = g:cached_dicts[startkey]
	endif
	
	let s:vis = a:vis
	call s:start_guide(rundict)
endf

function! leaderGuide#Start(vis, dict)
	"call leaderGuide#parseMappings()
	let s:vis = a:vis
	call s:start_guide(a:dict)
endfunction
