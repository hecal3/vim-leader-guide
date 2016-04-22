let s:save_cpo = &cpo
set cpo&vim

function! leaderGuide#register_prefix_descriptions(key, dictname) " {{{
    let key = a:key ==? '<Space>' ? ' ' : a:key
    if !exists('s:desc_lookup')
        call s:create_cache()
    endif
    if strlen(key) == 0
        let s:desc_lookup['top'] = a:dictname
        return
    endif
    if !has_key(s:desc_lookup, key)
        let s:desc_lookup[key] = a:dictname
    endif
endfunction "}}}
function! s:create_cache() " {{{
    let s:desc_lookup = {}
    let s:cached_dicts = {}
endfunction " }}}
function! s:create_target_dict(key) " {{{
    if has_key(s:desc_lookup, 'top')
        let toplevel = deepcopy({s:desc_lookup['top']})
        let tardict = s:toplevel ? toplevel : get(toplevel, a:key, {})
        let mapdict = s:cached_dicts[a:key]
        call s:merge(tardict, mapdict)
    elseif has_key(s:desc_lookup, a:key)
        let tardict = deepcopy({s:desc_lookup[a:key]})
        let mapdict = s:cached_dicts[a:key]
        call s:merge(tardict, mapdict)
    else
        let tardict = s:cached_dicts[a:key]
    endif
    return tardict
endfunction " }}}
function! s:merge(dict_t, dict_o) " {{{
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
                if g:leaderGuide_flatten == 0 || type(target[k]) == type({})
                    let target[k.'m'] = target[k]
                endif
                let target[k] = other[k]
                if has_key(other, k."m") && type(other[k."m"]) == type({})
                    call s:merge(target[k."m"], other[k."m"])
                endif
            endif
        endif
    endfor
    call extend(target, other, "keep")
endfunction " }}}

function! leaderGuide#populate_dictionary(key, dictname) " {{{
    call s:start_parser(a:key, s:cached_dicts[a:key])
endfunction " }}}
function! leaderGuide#parseMappings() " {{{
    for [k, v] in items(s:cached_dicts)
        call s:start_parser(k, v)
    endfor
endfunction " }}}


function! s:start_parser(key, dict) " {{{
    let key = a:key ==? ' ' ? "<Space>" : a:key
    let readmap = ""
    redir => readmap
    silent execute 'map '.key
    redir END
    let lines = split(readmap, "\n")

    for line in lines
        let mapd = maparg(split(line[3:])[0], line[0], 0, 1)
        if mapd.lhs =~ '<Plug>.*' || mapd.lhs =~ '<SNR>.*'
            continue
        endif
        let display = s:format_displaystring(mapd.rhs)
        let mapd.lhs = substitute(mapd.lhs, key, "", "")
        let mapd.lhs = substitute(mapd.lhs, "<Space>", " ", "g")
        let mapd.lhs = substitute(mapd.lhs, "<Tab>", "<C-I>", "g")
        let mapd.rhs = substitute(mapd.rhs, "<Space>", "<lt>Space>", "g")
        let mapd.rhs = substitute(mapd.rhs, "<SID>", "<SNR>".mapd['sid']."_", "g")
        if mapd.lhs != '' && display !~# 'LeaderGuide.*'
            if (s:vis && match(mapd.mode, "[vx ]") >= 0) ||
                        \ (!s:vis && match(mapd.mode, "[vx]") == -1)
            call s:add_map_to_dict(s:string_to_keys(mapd.lhs), mapd.rhs,
                        \display, 0, a:dict)
            endif
        endif
    endfor
endfunction " }}}

function! s:add_map_to_dict(key, cmd, desc, level, dict) " {{{
    if len(a:key) > a:level+1
        let curkey = a:key[a:level]
        let nlevel = a:level+1
        if !has_key(a:dict, curkey)
            let a:dict[curkey] = { 'name' : '' }
        " mapping defined already, flatten this map
        elseif type(a:dict[curkey]) == type([]) && g:leaderGuide_flatten
            let cmd = s:escape_mappings(a:cmd)
            let curkey = join(a:key[a:level+0:], '')
            let nlevel = a:level
            if !has_key(a:dict, curkey)
                let a:dict[curkey] = [cmd, a:desc]
            endif
        elseif type(a:dict[curkey]) == type([]) && g:leaderGuide_flatten == 0
            let cmd = s:escape_mappings(a:cmd)
            let curkey = curkey."m"
            if !has_key(a:dict, curkey)
                let a:dict[curkey] = {'name' : ''}
            endif
        endif
        " next level
        if type(a:dict[curkey]) == type({})
            call s:add_map_to_dict(a:key, a:cmd, a:desc, nlevel,
                        \a:dict[curkey])
        endif
    else
        let cmd = s:escape_mappings(a:cmd)
        if !has_key(a:dict, a:key[a:level])
            let a:dict[a:key[a:level]] = [cmd, a:desc]
        " spot is taken already, flatten existing submaps
        elseif type(a:dict[a:key[a:level]]) == type({}) && g:leaderGuide_flatten
            let childmap = s:flattenmap(a:dict[a:key[a:level]], a:key[a:level])
            for it in keys(childmap)
                let a:dict[it] = childmap[it]
            endfor
            let a:dict[a:key[a:level]] = [cmd, a:desc]
        endif
    endif
endfunction " }}}
function! s:format_displaystring(map) " {{{
    let g:leaderGuide#displayname = a:map
    for Fun in g:leaderGuide_displayfunc
        call Fun()
    endfor
    let display = g:leaderGuide#displayname
    unlet g:leaderGuide#displayname
    return display
endfunction " }}}
function! s:flattenmap(dict, str) " {{{
    let ret = {}
    for kv in keys(a:dict)
        if type(a:dict[kv]) == type([])
            let toret = {}
            let toret[a:str.kv] = a:dict[kv]
            return toret
        else
            let strcall = a:str.kv
            call extend(ret, s:flattenmap(a:dict[kv], a:str.kv))
        endif
    endfor
    return ret
endfunction " }}}


function! s:escape_mappings(string) " {{{
    let rstring = substitute(a:string, '\', '\\\\', 'g')
    let rstring = substitute(rstring, '<\([^<>]*\)>', '\\<\1>', 'g')
    let rstring = substitute(rstring, '"', '\\"', 'g')
    let rstring = 'call feedkeys("'.rstring.'", "mt")'
    return rstring
endfunction " }}}
function! s:string_to_keys(input) " {{{
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
endfunction " }}}
function! s:escape_keys(inp) " {{{
    let ret = substitute(a:inp, "<", "<lt>", "")
    return substitute(ret, "|", "<Bar>", "")
endfunction " }}}
function! s:show_displayname(inp) " {{{
    if has_key(s:displaynames, toupper(a:inp))
        return s:displaynames[toupper(a:inp)]
    else
        return a:inp
    end
endfunction " }}}
" displaynames {{{1 "
let s:displaynames = {'<C-I>': '<Tab>',
                    \ '<C-H>': '<BS>'}
" 1}}} "


function! s:calc_layout(dkmap) " {{{
    let ret = {}
    let smap = filter(copy(a:dkmap), 'v:key !=# "name"')
    let ret.n_items = len(smap)
    let length = values(map(smap, 
                \ 'strdisplaywidth("[".v:key."]".'.
                \ '(type(v:val) == type({}) ? v:val["name"] : v:val[1]))'))
    let maxlength = max(length) + g:leaderGuide_hspace
    if g:leaderGuide_vertical
        let ret.n_rows = winheight(0) - 2
        let ret.n_cols = ret.n_items / ret.n_rows + (ret.n_items != ret.n_rows)
        let ret.col_width = maxlength
        let ret.win_dim = ret.n_cols * ret.col_width
    else
        let ret.n_cols = winwidth(0) / maxlength
        let ret.col_width = winwidth(0) / ret.n_cols
        let ret.n_rows = ret.n_items / ret.n_cols + (fmod(ret.n_items,ret.n_cols) > 0 ? 1 : 0)
        let ret.win_dim = ret.n_rows
        "echom string(ret)
    endif
    return ret
endfunction " }}}
function! s:create_string(dkmap,layout) " {{{
    let l = a:layout
    let l.capacity = l.n_rows * l.n_cols
    let overcap = l.capacity - l.n_items
    let overh = l.n_cols - overcap
    let n_rows =  l.n_rows - 1

    let rows = []
    let row = 0
    let col = 0
    let smap = sort(filter(keys(a:dkmap), 'v:val !=# "name"'),'1')
    for k in smap
        let desc = type(a:dkmap[k]) == type({}) ? a:dkmap[k].name : a:dkmap[k][1]
        let displaystring = "[".s:show_displayname(k)."] ".desc
        let crow = get(rows, row, [])
        if empty(crow)
            call add(rows, crow)
        endif
        call add(crow, displaystring)
        call add(crow, repeat(' ', l.col_width - strdisplaywidth(displaystring)))

        if !g:leaderGuide_sort_horizontal
            if row >= n_rows - 1
                if overh > 0 && row < n_rows
                    let overh -= 1
                    let row += 1
                else
                    let row = 0
                    let col += 1
                endif
            else
                let row += 1
            endif
        else
            if col == l.n_cols - 1
                let row +=1
                let col = 0
            else
                let col += 1
            endif
        endif
        silent execute "cnoremap <nowait> <buffer> ".substitute(k, "|", "<Bar>", ""). " " . s:escape_keys(k) ."<CR>"
    endfor
    let r = []
    let mlen = 0
    for ro in rows
        let line = join(ro, '')
        call add(r, line)
        if strdisplaywidth(line) > mlen
            let mlen = strdisplaywidth(line)
        endif
    endfor
    call insert(r, '')
    let output = join(r, "\n ")
    cnoremap <nowait> <buffer> <Space> <Space><CR>
    return output
endfunction " }}}


function! s:start_buffer(lmap) " {{{
    let s:winv = winsaveview()
    let s:winnr = winnr()
    let s:winres = winrestcmd()
    call s:winopen()
    let layout = s:calc_layout(a:lmap)
    let string = s:create_string(a:lmap, layout)

    setlocal modifiable
    if g:leaderGuide_vertical
        execute 'vert res '.layout.win_dim
    else
        execute 'res '.layout.win_dim
    endif

    silent $put=string
    setlocal nomodifiable nolist
    redraw
    let inp = input("")
    if inp !=# '' && inp!=? "<lt>ESC>"
        let fsel = get(a:lmap, inp)
    else
        let fsel = ['call feedkeys("\<ESC>")']
    endif
    call s:winclose()
    if type(fsel) ==? type({})
        call s:start_buffer(fsel)
    else
        call feedkeys(s:vis.s:reg.s:count, 'ti')
        redraw
        try
            execute fsel[0]
        catch
            echom v:exception
        endtry
    endif
endfunction " }}}
function! s:winopen() " {{{
    if !exists('s:bufnr')
        let s:bufnr = -1
    endif
    let pos = g:leaderGuide_position ==? 'topleft' ? 'topleft' : 'botright'
    if bufexists(s:bufnr)
        let qfbuf = &buftype ==# 'quickfix'
        let splitcmd = g:leaderGuide_vertical ? ' 1vs' : ' 1sp'
        execute pos.splitcmd
        let bnum = bufnr('%')
        execute    'buffer '.s:bufnr
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
endfunction " }}}
function! s:winclose() " {{{
    if s:gwin == winnr()
        close
        exe s:winres
        let s:gwin = -1
        execute s:winnr.'wincmd w'
        call winrestview(s:winv)
    endif
endfunction " }}}


function! leaderGuide#start_by_prefix(vis, key) " {{{
    let s:vis = a:vis ? 'gv' : ''
    let s:count = v:count != 0 ? v:count : ''
    let s:reg = v:register != '"' ? '"'.v:register : ''
    let s:toplevel = a:key ==? '  '

    if !has_key(s:cached_dicts, a:key) || g:leaderGuide_run_map_on_popup
        "first run
        let s:cached_dicts[a:key] = {}
        call s:start_parser(a:key, s:cached_dicts[a:key])
    endif
    
    if has_key(s:desc_lookup, a:key) || has_key(s:desc_lookup , 'top')
        let rundict = s:create_target_dict(a:key)
    else
        let rundict = s:cached_dicts[a:key]
    endif

    call s:start_buffer(rundict)
endfunction " }}}
function! leaderGuide#start(vis, dict) " {{{
    let s:vis = a:vis ? 'gv' : 0
    call s:start_buffer(a:dict)
endfunction " }}}

let &cpo = s:save_cpo
unlet s:save_cpo
