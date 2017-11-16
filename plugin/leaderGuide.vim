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

" ---- DICTIONARY {{{
" let g:lmap = {}
"
" " buffer management
" let g:lmap.b = { 'name': 'Buffer Commands' }
" let g:lmap.b.l = [':ls', 'list open buffers']
" let g:lmap.b.b = ['call feedkeys(":b")', 'open buffer ...']
" let g:lmap.b.c = ['checkt', 'Reload buffers from disk']
"
" " editing
" let g:lmap.i = {'name': 'Insert'}
" let g:lmap.i.s = ['sort u', 'Sort selected']
" let g:lmap.i.d = ['"_dd', 'Bufferless delete line']
" let g:lmap.i.dw = ['"_daw', 'Bufferless delete word']
"
" " DELETE {{{
"
" let g:lmap.i.d = {
"   \'name': 'Delete',
"   \'.': ['call feedkeys("x")', 'Under cursor'],
"   \'l': ['call feedkeys("dd")', 'Current line (cut)'],
"   \'w': ['call feedkeys("diw")', 'Current word'],
"   \'$': ['call feedkeys("d$")', 'To end of line'],
"   \'0': ['call feedkeys("d0")', 'To beginning of line'],
" \}
"
" let g:lmap.i.d['_'] = {
"   \'name': 'Bufferless',
"   \'.': ['call feedkeys("\"_x")', 'Under cursor'],
"   \'l': ['call feedkeys("\"_dd")', 'Current line'],
"   \'w': ['call feedkeys("\"_diw")', 'Current word'],
"   \'$': ['call feedkeys("\"_d$")', 'To end of line'],
"   \'0': ['call feedkeys("\"_d0")', 'To beginning of line'],
" \}
"
" " }}}
"
" " CASE {{{
"
" let g:lmap.i.c = {
"   \'name': 'Change Case',
"   \'.': ['call feedkeys("~")', 'Under Cursor (~)'],
"   \'w': ['call feedkeys("g~iw")', 'Current Word'],
"   \'l': ['call feedkeys("g~~")', 'Current Line'],
"   \'$': ['call feedkeys("g~$")', 'To end of line'],
"   \'0': ['call feedkeys("g~0")', 'To beginning of line'],
" \}
"
" let g:lmap.i.c.u = {
"   \'name': 'UPPERCASE',
"   \'.': ['call feedkeys("gUl")', 'Under cursor'],
"   \'w': ['call feedkeys("gUiw")', 'Current word'],
"   \'l': ['call feedkeys("gUU")', 'Current line'],
"   \'$': ['call feedkeys("gU$")', 'To end of line'],
"   \'0': ['call feedkeys("gU0")', 'To beginning of line'],
" \}
"
" let g:lmap.i.c.l = {
"   \'name': 'lowercase',
"   \'.': ['call feedkeys("gul")', 'Under cursor'],
"   \'w': ['call feedkeys("guiw")', 'Current word'],
"   \'l': ['call feedkeys("guu")', 'Current line'],
"   \'$': ['call feedkeys("gu$")', 'To end of line'],
"   \'0': ['call feedkeys("gu0")', 'To beginning of line'],
" \}
"
" " }}}
"
" " git
" let g:lmap.g = {'name': 'Git commands'}
" let g:lmap.g.s = ["Gstatus", "Status"]
" let g:lmap.g.c = ["Gcommit -v", "Commit -verbose"]
" let g:lmap.g.p = ["call feedkeys(':Gpush ')", "Git Push ..."]
" let g:lmap.g.l = ["Gpull", "Git Pull"]
" let g:lmap.g.d = ["Gdiff", "Diff"]
" let g:lmap.g.q = ["Glog", "Load revisions to QuickFix"]
"
" " tabs/windows/splits
" let g:lmap.t = {'name': 'Windows/Tabs/Splits'}
" let g:lmap.t.v = [':vsplit', 'Split Vertical']
" let g:lmap.t.h = [':split', 'Split Horizontal']
"
" " file control {{{
" let g:lmap.f = {'name': 'File'}
" let g:lmap.f.Q = ['qall!', 'Quit all']
" let g:lmap.f.RC = ['call feedkeys(":tabe $MYVIMRC\<CR>:vsplit\<cr>:e $shortcuts\<cr>")', 'Open vimrc and leaderGuide file']
" let g:lmap.f.c = ['checkt', 'Reload buffers from disk']
" let g:lmap.f.e = ['call feedkeys(":e ")', 'Edit file ...']
" let g:lmap.f.g = ['call feedkeys("gf")', 'Goto file under cursor']
" let g:lmap.f.q = ['q', 'Quit current buffer']
" let g:lmap.f.r = ['call feedkeys(":r ")', 'Insert file at cursor ...']
" let g:lmap.f.rc = ['tabe $MYVIMRC', 'Open vimrc in split']
" let g:lmap.f.s = ['tabe $shortcuts', 'Open leader-guide file']
" let g:lmap.f.v = ['source $MYVIMRC', 'source vimrc']
" let g:lmap.f.w = [':w', 'Write current buffer']
" let g:lmap.f.wq = [':wq', 'Write and quit']
"
" " }}}
"
" " shell commands
" let g:lmap.z = {'name': 'Shell Commands'}
" let g:lmap.z["!"] = ['call feedkeys(":!")', 'Execute shell command ...']
"
" " registers
" let g:lmap.r = {'name': 'Registers'}
" let g:lmap.r.l = ['reg', 'List all registers']
"
" " screen/cursor
" let g:lmap.c = {'name': 'Cursor'}
" let g:lmap.c.c = ['call feedkeys("z.")', 'Center on cursor']
" let g:lmap.c.t = ['call feedkeys("zt")', 'Scroll to cursor at top']
" let g:lmap.c.b = ['call feedkeys("zb")', 'Scroll to cursor at bottom']
" let g:lmap.c.p = ['call feedkeys("`\"")', 'Goto last cursor position']
" let g:lmap.c.i = ['call feedkeys("`.")', 'Goto position of last edit']
" let g:lmap.c['^'] = ['call feedkeys("`^")', 'Goto position of last insert']
"
" " search
" let g:lmap.s = {'name': 'Search'}
" let g:lmap.s.h = ['call feedkeys("q/")', 'Edit Search History']
" let g:lmap.s['/'] = ['call feedkeys("/")', 'Search this buffer']
" let g:lmap.s.a = ['call feedkeys(":Ag ")', 'Silver Searcher']
" let g:lmap.s.n = ['noh', 'Unhilight search term']
"
" " marks
" let g:lmap.m = {'name': 'Marks'}
"
" " Plugins
" " DevDocs
" let g:lmap.p = {'name': 'Plugins'}
" let g:lmap.p.d = {'name': 'DevDocs'}
" let g:lmap.p.d.c = [':DevDocsUnderCursor', 'Search Dev Docs at cursor']
" let g:lmap.p.d.s = [':DevDocs %', 'Search']
"
" " CtrlP
" let g:lmap.p.p = {'name': 'Ctrl-P fuzzy file finder'}
" let g:lmap.p.p.p = ['CtrlP', 'Open fuzzy finder']
" let g:lmap.p.p.c = ['CtrlPCmdPalette', 'Open Control Palette']
"
" " NerdTree
" let g:lmap.p["\\"] = {'name': 'NERDTree'}
" let g:lmap.p["\\"].o = ['NERDTree', 'Open NERDTree']
"
" " Prettier
" silent! unmap <leader>p
" let g:lmap.p.r = {'name': 'Prettier'}
" let g:lmap.p.r.f = ['PrettierAsync', 'Format current buffer']
"
" " Tabularize
" let g:lmap.p.t = {'name': 'Tabularize'}
" let g:lmap.p.t.a = ['Tab', 'Auto Tabularize']
" let g:lmap.p.t.g = ['call feedkeys(":Tab /")', 'Tabularize on ...']
" let g:lmap.p.t.s = ['call feedkeys(":sort<space>u<cr>gv:Tabularize/:")', 'Sort and tab on ...']
" let g:lmap.p.t[':'] = ['Tabularize/:/', 'Tabularize on :']
" let g:lmap.p.t['='] = ['Tabularize/=/', 'Tabularize on =']
"
" }}}
