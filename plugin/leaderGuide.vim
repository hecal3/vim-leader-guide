if exists('loaded_leaderGuide_vim') || &cp
    finish
endif
let loaded_leaderGuide_vim = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:leaderGuide_vertical')
    let g:leaderGuide_vertical = 0
endif

if !exists('g:leaderGuide_sort_horizontal')
    let g:leaderGuide_sort_horizontal = 0
endif

if !exists('g:leaderGuide_position')
    let g:leaderGuide_position = 'botright'
endif

if !exists('g:leaderGuide_run_map_on_popup')
    let g:leaderGuide_run_map_on_popup = 1
endif

if !exists("g:leaderGuide_hspace")
    let g:leaderGuide_hspace = 5
endif

if !exists("g:leaderGuide_flatten")
    let g:leaderGuide_flatten = 1
endif

if !exists("g:leaderGuide_default_group_name")
    let g:leaderGuide_default_group_name = ""
endif

if !exists("g:leaderGuide_max_size")
    let g:leaderGuide_max_size = 0
endif

if !exists("g:leaderGuide_submode_mappings")
    let g:leaderGuide_submode_mappings = {'<C-C>': "win_close"}
endif

if !exists("g:leaderGuide_displayfunc")
    function! s:leaderGuide_display()
        let g:leaderGuide#displayname = substitute(g:leaderGuide#displayname, '\c<cr>$', '', '')
    endfunction
    let g:leaderGuide_displayfunc = [function("s:leaderGuide_display")]
endif

if !leaderGuide#has_configuration()
    let g:leaderGuide_map = {}
    call leaderGuide#register_prefix_descriptions('', 'g:leaderGuide_map')
endif

command -nargs=1 LeaderGuideD call leaderGuide#start('0', <args>)
command -range -nargs=1 LeaderGuideVisualD call leaderGuide#start('1', <args>)

command -nargs=1 LeaderGuide call leaderGuide#start_by_prefix('0', <args>)
command -range -nargs=1 LeaderGuideVisual call leaderGuide#start_by_prefix('1', <args>)

nnoremap <silent> <Plug>leaderguide-buffer :<C-U>call leaderGuide#start_by_prefix('0', '<buffer>')<CR>
vnoremap <silent> <Plug>leaderguide-buffer :<C-U>call leaderGuide#start_by_prefix('1', '<buffer>')<CR>
nnoremap <silent> <Plug>leaderguide-global :<C-U>call leaderGuide#start_by_prefix('0', '  ')<CR>
vnoremap <silent> <Plug>leaderguide-global :<C-U>call leaderGuide#start_by_prefix('1', '  ')<CR>

let &cpo = s:save_cpo
unlet s:save_cpo
