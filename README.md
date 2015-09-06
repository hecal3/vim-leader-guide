# vim-leader-guide

vim-leader-guide is a vim keymap-display loosely inspired by emacs's [guide-key](https://github.com/kai2nenobu/guide-key).

![img1.png](https://raw.githubusercontent.com/hecal3/vim-leader-guide/master/img1.png)

## Usage Examples
The plugin configuration is based on vim's dictionarys.

```vim
let g:lmap =  {}
" Top level dictionary
let g:lmap.main = {
				\'g' : ['LeaderGuide g:lmap.g', 'Git Menu'],
				\'f' : ['LeaderGuide g:lmap.f', 'File Menu'],
				\'o' : ['LeaderGuide g:lmap.o', 'Open stuff'],
				\}
" Second level dictionarys:
let g:lmap.f = {}
let g:lmap.o = {}
" Document existing keymappings:
	nmap <silent> <leader>fd :e $MYVIMRC<CR>
	let g:lmap.f.d = ['e $MYVIMRC', 'Open vimrc']

	nmap <silent> <leader>fs :so %<CR>
	let g:lmap.f.s = ['so %', 'Source file']

	nmap <silent> <leader>oo  :copen<CR>
	let g:lmap.o.o = ['copen', 'Open quickfix']

	nmap <silent> <leader>ol  :lopen<CR>
	let g:lmap.o.l = ['lopen', 'Open locationlist']

	nmap <silent> <leader>fw :w<CR>
	let g:lmap.f.w = ['w', 'Write file']

" Create new menus not based on existing mappings:
let g:lmap.g = {
				\'s' : ['Gstatus', 'Git Status'],
                \'p' : ['Gpull',   'Git Pull'],
                \'u' : ['Gpush',   'Git Push'],
                \'c' : ['Gcommit', 'Git Commit'],
                \'w' : ['Gwrite',  'Git Write'],
                \}

" Plugin mapping
nnoremap <silent> <leader> :LeaderGuide g:lmap.main<CR>
```

Try pressing leader.
The top-level will pop up depending on you timeoutlen setting.

Alternatively press leader-f. Assuming leader-f is not mapped otherwise, the plugin will take straight to the file sub-menu.

Despite its name this plugin is not limited to the leader-key. Other first level mappings will work as well.

## Special keys and Mappings

```vim
" Special key mapping:
let g:lmap.g = {
				\'<tab>' : ['Gstatus', 'Git Status'],
                \'<BS>' : ['Gpull',   'Git Pull'],
                \'<C-P>' : ['Gpush',   'Git Push'],
                \'c' : ['Gcommit', 'Git Commit'],
                \'w' : ['Gwrite',  'Git Write'],
                \}
" Trigger other mappings:
let g:lmap.main[','] = ['call feedkeys("\<Plug>(easymotion-prefix)")', 'EasyMotion Prefix']
```

## Other settings

Popup position:

```vim
" Bottom (default)
" let g:leaderGuide_vertical = 0
" let g:leaderGuide_position = 'botright'

" Top
let g:leaderGuide_position = 'topleft'

" Left
let g:leaderGuide_vertical = 1
let g:leaderGuide_position = 'topleft'

" Right
let g:leaderGuide_vertical = 1
let g:leaderGuide_position = 'botright'

" General command
:LeaderGuide {dict}
```

![img2.png](https://raw.githubusercontent.com/hecal3/vim-leader-guide/master/img2.png)

## TODO and Ideas

1. Documentation
2. Visual Mappings
3. The redefintion of existing leader-mappings is clunky and verbose. It might be possible to automate this(read existing mappings).
