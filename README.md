# vim-leader-guide

vim-leader-guide is a vim keymap-display loosely inspired by emacs's [guide-key](https://github.com/kai2nenobu/guide-key).

![img1.png](https://raw.githubusercontent.com/hecal3/vim-leader-guide/master/img1.png)

## Usage Examples
The plugin configuration is based on vim's dictionarys.

```vim
" Define Top Level Dictionary
let g:lmap =  {}

" Second level dictionarys:
let g:lmap.f = { 'name' : 'File Menu' }
let g:lmap.o = { 'name' : 'Open Stuff' }

" You will need one top level dictionary per prefix key.
" The naming scheme is imporant for the keymap parser.

" Document existing keymappings:
	nmap <silent> <leader>fd :e $MYVIMRC<CR>
	let g:lmap.f.d = ['e $MYVIMRC', 'Open vimrc']

	nmap <silent> <leader>fs :so %<CR>
	" let g:lmap.f.s = ['so %', 'Source file']

	nmap <silent> <leader>oo  :copen<CR>
	" let g:lmap.o.o = ['copen', 'Open quickfix']

	nmap <silent> <leader>ol  :lopen<CR>
	" let g:lmap.o.l = ['lopen', 'Open locationlist']

	nmap <silent> <leader>fw :w<CR>
	" let g:lmap.f.w = ['w', 'Write file']

" Create new menus not based on existing mappings:
let g:lmap.g = {
				\'name' : 'Git Menu',
				\'s' : ['Gstatus', 'Git Status'],
                \'p' : ['Gpull',   'Git Pull'],
                \'u' : ['Gpush',   'Git Push'],
                \'c' : ['Gcommit', 'Git Commit'],
                \'w' : ['Gwrite',  'Git Write'],
                \}

" Leader + timeoutlen opens the main menu
nnoremap <silent> <leader> :LeaderGuide g:lmap.main<CR>
vnoremap <silent> <leader> :LeaderGuideVisual g:lmap.main<CR>

" Populate the Dictionary depending on your <leader> key:
call leaderGuide#PopulateDictionary("<Space>","g:lmap")
" or
" call leaderGuide#PopulateDictionary(",","g:lmap")

" Mappings you did not define manualle should work as well.
" Instead of an description the command itself will be displayed
" The populateDictionary function will not overwrite mappings,
" descriptions or group names you defined manually.


" Another Map for the localleader-prefix:
let g:anotherdict = {}
" No renaming and descriptions, just get the mappings:
call leaderGuide#PopulateDictionary(",","g:anotherdict")
" call the addon
nnoremap <silent> <localleader> :LeaderGuide g:anotherdict<CR>
vnoremap <silent> <localleader> :LeaderGuideVisual g:anotherdict<CR>

```

Try pressing leader.
The top-level will pop up depending on you timeoutlen setting, awaiting further keystrokes.

Alternatively press leader-f. Assuming leader-f is not mapped otherwise you will end up in the file menu.

Please note that no matter which mappings and menus you configure, your original leader mappings will remain unaffected.
The key guide is an additional layer. It will only activate, when you do not complete your input during the timeoutlen duration.


## Special keys and Mappings

```vim
" Special key mapping:
let g:lmap.g = {
				\'<tab>' : ['Gstatus', 'Git Status'],
                \'<BS>'  : ['Gpull',   'Git Pull'],
                \'<C-P>' : ['Gpush',   'Git Push'],
                \'/'     : ['Gcommit', 'Git Commit'],
                \'<F4>'  : ['Gwrite',  'Git Write'],
                \' '     : ['ThisIsSpace',  'SomeDescription'],
                \}

" Call other mappings ( Trigger with <leader>, ):
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

```

![img2.png](https://raw.githubusercontent.com/hecal3/vim-leader-guide/master/img2.png)

## TODO and Ideas

- Documentation
- The redefintion of existing leader-mappings is clunky and verbose. It might be possible to automate this(read existing mappings).
