let g:guide = {}
let g:vguide = {}

function! CmdMenu_feedkeys_input(prompt, command)
  let finput = input(a:prompt)
  call feedkeys(':' . a:command . ' ' . finput . "\<cr>")
endfunction

let g:guide.h = ['call CmdMenu_feedkeys_input("help for: ", ":h ")', 'help ...']

" buffer management {{{
function! CmdMenu_buffer_list_and_open(command)
  ls
  let finput = input("buffer no: ")
  call feedkeys("\<cr>")
  execute(finput . a:command)
endfunction

let g:guide.b = {
  \'name': 'BUFFER',
  \'l': [':ls', 'list open buffers'],
  \'b': ['call CmdMenu_buffer_list_and_open("b")', 'open buffer ...'],
  \'B': ['call CmdMenu_buffer_list_and_open("sbuffer")', 'open buffer ... in split'],
  \'c': ['checkt', 'reload buffers from disk'],
  \'u': ['bdelete', 'delete current buffer'],
  \'U': ['bdelete!', 'delete current buffer w/o write'],
  \'s': ['split scratch', 'open scratch buffer in split'],
  \'S': ['tabe scratch', 'open scratch buffer in tab'],
\} " }}}
" left to implement:
" ball
" sball

" editing {{{
let g:guide.i = {
  \'name': 'INSERT',
  \}

  " DELETE {{{
  let g:guide.i.d = {
    \'name': 'DELETE',
    \'.': ['call feedkeys("x")', 'Under cursor'],
    \'l': ['call feedkeys("dd")', 'Current line (cut)'],
    \'w': ['call feedkeys("diw")', 'Current word'],
    \'$': ['call feedkeys("d$")', 'To end of line'],
    \'0': ['call feedkeys("d0")', 'To beginning of line'],
  \}

  let g:guide.i.d['_'] = {
    \'name': 'BUFFERLESS',
    \'.': ['call feedkeys("\"_x")', 'Under cursor'],
    \'l': ['call feedkeys("\"_dd")', 'Current line'],
    \'w': ['call feedkeys("\"_diw")', 'Current word'],
    \'$': ['call feedkeys("\"_d$")', 'To end of line'],
    \'0': ['call feedkeys("\"_d0")', 'To beginning of line'],
  \}
  " }}}

  " CASE {{{
  let g:guide.i.c = {
    \'name': 'CASE',
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
    \'name': 'LOWERCASE',
    \'.': ['call feedkeys("gul")', 'Under cursor'],
    \'w': ['call feedkeys("guiw")', 'Current word'],
    \'l': ['call feedkeys("guu")', 'Current line'],
    \'$': ['call feedkeys("gu$")', 'To end of line'],
    \'0': ['call feedkeys("gu0")', 'To beginning of line'],
  \}
  " }}}
" }}}

" git {{{
let g:guide.g = {
  \'name': 'GIT (FUGITIVE)',
  \'s': ["Gstatus", "Status"],
  \'c': ["Gcommit -v", "Commit -verbose"],
  \'p': ["call feedkeys(':Gpush ')", "Git Push ..."],
  \'l': ["Gpull", "Git Pull"],
  \'d': ["Gdiff", "Diff"],
  \'q': ["Glog", "Load revisions to QuickFix"],
\} " }}}

" tabs/windows/splits {{{
let g:guide.t = {
  \'name': 'TABS AND SPLITS',
  \'v': [':vsplit', 'Split Vertical'],
  \'h': [':split', 'Split Horizontal'],
  \'n': [':tabNext', 'Next Tab'],
  \'N': [':tabprevious', 'Previous Tab'],
  \'l': [':tabs', 'List tab pages and windows'],
  \'g': [':tabfirst', 'Goto first tab'],
  \'G': [':tablast', 'Goto last tab'],
\} " }}}

" file control {{{
let g:guide.f = {
  \'name': 'FILE',
  \'q': ['q', 'Quit current buffer'],
  \'Q': ['qall!', 'Quit all'],
  \'!': ['q!', 'Quit buffer w/o save'],
  \'c': ['checkt', 'Reload buffers from disk'],
  \'e': ['call feedkeys(":e ")', 'Edit file ...'],
  \'g': ['call feedkeys("gf")', 'Goto file under cursor'],
  \'G': ['call feedkeys("<ctrl-G>")', 'Where am I?'],
  \'r': ['call feedkeys(":r ")', 'Insert file at cursor ...'],
  \'t': ['tabe $MYVIMRC', 'Open vimrc in tab'],
  \'v': ['source $MYVIMRC', 'source vimrc'],
  \'w': [':w', 'Write current buffer'],
  \'W': [':wq', 'Write and quit'],
\} " }}}

" shell commands {{{
let g:guide.z = {
  \'name': 'SHELL',
  \'!': ['call feedkeys(":!")', 'Execute shell command ...'],
\} " }}}

" registers {{{
let g:guide.r = {
  \'name': 'REGISTERS',
  \'l': ['reg', 'List all registers'],
\} " }}}

" screen/cursor {{{
let g:guide.c = {
  \'name': 'CURSOR',
  \'b': ['call feedkeys("zb")', 'Scroll to cursor at bottom'],
  \'c': ['call feedkeys("z.")', 'Center on cursor'],
  \'g': ['call feedkeys("gg")', 'Scroll to top'],
  \'G': ['call feedkeys("G")', 'Scroll to bottom'],
  \'i': ['call feedkeys("`.")', 'Goto position of last edit'],
  \'p': ['call feedkeys("`\"")', 'Goto last cursor position'],
  \'t': ['call feedkeys("zt")', 'Scroll to cursor at top'],
  \'^': ['call feedkeys("`^")', 'Goto position of last insert'],
\} " }}}

" search {{{
let g:guide.s = {
  \'name': 'SEARCH',
  \'a': ['call feedkeys(":Ag ")', 'Silver Searcher'],
  \'h': ['call feedkeys("q/")', 'Edit Search History'],
  \'n': ['noh', 'Unhilight search term'],
  \'/': ['call feedkeys("/")', 'Search this buffer'],
\} " }}}

" marks {{{
let g:guide.m = {
  \'name': 'MARKS',
  \'~': ['call feedkeys("``")', 'Back from last jump'],
  \'a': ['call feedkeys("ma")', 'Mark a'],
  \'m': ['call feedkeys("m")', 'Create mark ...'],
  \'A': ['call feedkeys("`a")', 'Goto mark a'],
  \'M': ['call feedkeys("`")', 'Goto mark ...'],
  \} " }}}

" Plugins {{{
  let g:guide.p = {'name': 'Plugins'}

  " DevDocs {{{
  if !empty(glob(g:PLUGIN_PATH . "/devdocs.vim"))
    let g:guide.p.d = {
      \'name': 'DevDocs',
      \'c': [':DevDocsUnderCursor', 'Search Dev Docs at cursor'],
      \'s': [':DevDocs %', 'Search'],
    \}
  endif " }}}

  " CtrlP {{{
  let g:guide.p.p = {
    \'name': 'Ctrl-P fuzzy file finder',
    \'p': ['CtrlP', 'Open fuzzy finder'],
    \'c': ['CtrlPCmdPalette', 'Open Control Palette']
  \} " }}}

  " NerdTree {{{
  let g:guide.p["\\"] = {
    \'name': 'NERDTree',
    \'o':['NERDTree', 'Open NERDTree'],
  \} " }}}

  " Prettier {{{
  silent! unmap <leader>p
  let g:guide.p.r = {
    \'name': 'Prettier',
    \'f': ['PrettierAsync', 'Format current buffer'],
  \} " }}}

  " Tabularize {{{
  let g:guide.p.t = {
    \'name': 'Tabularize',
    \'a': ['Tab', 'Auto Tabularize'],
    \'g': ['call feedkeys(":Tab /")', 'Tabularize on ...'],
    \'s': ['call feedkeys(":sort<space>u<cr>gv:Tabularize/:")', 'Sort and tab on ...'],
    \':': ['Tabularize/:/', 'Tabularize on :'],
    \'=': ['Tabularize/=/', 'Tabularize on ='],
  \} "}}}
" }}}

nnoremap <space> :call<space>leaderGuide#start('0',<space>g:guide)<cr>
vnoremap <space> :<bs><bs><bs><bs><bs>call<space>leaderGuide#start('0',<space>g:vguide)<cr>
