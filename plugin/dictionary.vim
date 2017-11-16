let g:guide = {}

" buffer management {{{
let g:guide.b = { 'name': 'Buffer Commands' }
let g:guide.b.l = [':ls', 'list open buffers']
let g:guide.b.b = ['call feedkeys(":b")', 'open buffer ...']
let g:guide.b.c = ['checkt', 'Reload buffers from disk']
" }}}

" editing {{{
let g:guide.i = {'name': 'Insert'}
let g:guide.i.s = ['sort u', 'Sort selected']

" DELETE {{{

let g:guide.i.d = {
  \'name': 'Delete',
  \'.': ['call feedkeys("x")', 'Under cursor'],
  \'l': ['call feedkeys("dd")', 'Current line (cut)'],
  \'w': ['call feedkeys("diw")', 'Current word'],
  \'$': ['call feedkeys("d$")', 'To end of line'],
  \'0': ['call feedkeys("d0")', 'To beginning of line'],
\}

let g:guide.i.d['_'] = {
  \'name': 'Bufferless',
  \'.': ['call feedkeys("\"_x")', 'Under cursor'],
  \'l': ['call feedkeys("\"_dd")', 'Current line'],
  \'w': ['call feedkeys("\"_diw")', 'Current word'],
  \'$': ['call feedkeys("\"_d$")', 'To end of line'],
  \'0': ['call feedkeys("\"_d0")', 'To beginning of line'],
\}

" }}}

" CASE {{{

let g:guide.i.c = {
  \'name': 'Change Case',
  \'.': ['call feedkeys("~")', 'Under Cursor (~)'],
  \'w': ['call feedkeys("g~iw")', 'Current Word'],
  \'l': ['call feedkeys("g~~")', 'Current Line'],
  \'$': ['call feedkeys("g~$")', 'To end of line'],
  \'0': ['call feedkeys("g~0")', 'To beginning of line'],
\}

let g:guide.i.c.u = {
  \'name': 'UPPERCASE',
  \'.': ['call feedkeys("gUl")', 'Under cursor'],
  \'w': ['call feedkeys("gUiw")', 'Current word'],
  \'l': ['call feedkeys("gUU")', 'Current line'],
  \'$': ['call feedkeys("gU$")', 'To end of line'],
  \'0': ['call feedkeys("gU0")', 'To beginning of line'],
\}

let g:guide.i.c.l = {
  \'name': 'lowercase',
  \'.': ['call feedkeys("gul")', 'Under cursor'],
  \'w': ['call feedkeys("guiw")', 'Current word'],
  \'l': ['call feedkeys("guu")', 'Current line'],
  \'$': ['call feedkeys("gu$")', 'To end of line'],
  \'0': ['call feedkeys("gu0")', 'To beginning of line'],
\}

" }}}

" }}}

" git {{{
let g:guide.g = {'name': 'Git commands'}
let g:guide.g.s = ["Gstatus", "Status"]
let g:guide.g.c = ["Gcommit -v", "Commit -verbose"]
let g:guide.g.p = ["call feedkeys(':Gpush ')", "Git Push ..."]
let g:guide.g.l = ["Gpull", "Git Pull"]
let g:guide.g.d = ["Gdiff", "Diff"]
let g:guide.g.q = ["Glog", "Load revisions to QuickFix"]

" }}}

" tabs/windows/splits {{{

let g:guide.t = {'name': 'Windows/Tabs/Splits'}
let g:guide.t.v = [':vsplit', 'Split Vertical']
let g:guide.t.h = [':split', 'Split Horizontal']

" }}}

" file control {{{

let g:guide.f = {'name': 'File'}
let g:guide.f.Q = ['qall!', 'Quit all']
let g:guide.f.c = ['checkt', 'Reload buffers from disk']
let g:guide.f.e = ['call feedkeys(":e ")', 'Edit file ...']
let g:guide.f.g = ['call feedkeys("gf")', 'Goto file under cursor']
let g:guide.f.q = ['q', 'Quit current buffer']
let g:guide.f.r = ['call feedkeys(":r ")', 'Insert file at cursor ...']
let g:guide.f.rc = ['tabe $MYVIMRC', 'Open vimrc in split']
let g:guide.f.v = ['source $MYVIMRC', 'source vimrc']
let g:guide.f.w = [':w', 'Write current buffer']
let g:guide.f.W = [':wq', 'Write and quit']

" }}}

" shell commands {{{

let g:guide.z = {'name': 'Shell Commands'}
let g:guide.z["!"] = ['call feedkeys(":!")', 'Execute shell command ...']

" }}}

" registers {{{

let g:guide.r = {'name': 'Registers'}
let g:guide.r.l = ['reg', 'List all registers']

" }}}

" screen/cursor {{{

let g:guide.c = {'name': 'Cursor'}
let g:guide.c.c = ['call feedkeys("z.")', 'Center on cursor']
let g:guide.c.t = ['call feedkeys("zt")', 'Scroll to cursor at top']
let g:guide.c.b = ['call feedkeys("zb")', 'Scroll to cursor at bottom']
let g:guide.c.p = ['call feedkeys("`\"")', 'Goto last cursor position']
let g:guide.c.i = ['call feedkeys("`.")', 'Goto position of last edit']
let g:guide.c['^'] = ['call feedkeys("`^")', 'Goto position of last insert']

" }}}

" search {{{

let g:guide.s = {'name': 'Search'}
let g:guide.s.h = ['call feedkeys("q/")', 'Edit Search History']
let g:guide.s['/'] = ['call feedkeys("/")', 'Search this buffer']
let g:guide.s.a = ['call feedkeys(":Ag ")', 'Silver Searcher']
let g:guide.s.n = ['noh', 'Unhilight search term']

" }}}

" marks {{{

let g:guide.m = {'name': 'Marks'}

" }}}

" Plugins {{{
" DevDocs {{{
let g:guide.p = {'name': 'Plugins'}
let g:guide.p.d = {'name': 'DevDocs'}
let g:guide.p.d.c = [':DevDocsUnderCursor', 'Search Dev Docs at cursor']
let g:guide.p.d.s = [':DevDocs %', 'Search']
" }}}

" CtrlP {{{
let g:guide.p.p = {'name': 'Ctrl-P fuzzy file finder'}
let g:guide.p.p.p = ['CtrlP', 'Open fuzzy finder']
let g:guide.p.p.c = ['CtrlPCmdPalette', 'Open Control Palette']
" }}}

" NerdTree {{{
let g:guide.p["\\"] = {'name': 'NERDTree'}
let g:guide.p["\\"].o = ['NERDTree', 'Open NERDTree']
" }}}

" Prettier {{{
silent! unmap <leader>p
let g:guide.p.r = {'name': 'Prettier'}
let g:guide.p.r.f = ['PrettierAsync', 'Format current buffer']
" }}}

" Tabularize {{{
let g:guide.p.t = {'name': 'Tabularize'}
let g:guide.p.t.a = ['Tab', 'Auto Tabularize']
let g:guide.p.t.g = ['call feedkeys(":Tab /")', 'Tabularize on ...']
let g:guide.p.t.s = ['call feedkeys(":sort<space>u<cr>gv:Tabularize/:")', 'Sort and tab on ...']
let g:guide.p.t[':'] = ['Tabularize/:/', 'Tabularize on :']
let g:guide.p.t['='] = ['Tabularize/=/', 'Tabularize on =']
"}}}

" }}}

nnoremap <space> :call<space>leaderGuide#start('0',<space>g:guide)<cr>
