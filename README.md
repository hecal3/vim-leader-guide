# vim-leader-guide

vim-leader-guide is a vim keymap-display loosely inspired by emacs's [guide-key](https://github.com/kai2nenobu/guide-key).

This Plugin is not stable yet. The configuration and commands might change in the future.

![img1.png](https://raw.githubusercontent.com/hecal3/vim-leader-guide/master/img1.png)


![img3.png](https://raw.githubusercontent.com/hecal3/vim-leader-guide/master/img3.png)

## Usage Examples
The plugin configuration is based on vim's dictionarys.

```vim
" Define Top Level Dictionary
let g:lmap =  {}

" Second level dictionarys:
let g:lmap.f = { 'name' : 'File Menu' }
let g:lmap.o = { 'name' : 'Open Stuff' }
" 'name' is a special field. It will define the name of the group.
" leader-f is the "File Menu" group.
" Unnamed groups will show a default string

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

" If you use NERDCommenter:
let g:lmap.c = { 'name' : 'Comments' }
" Define some Descriptions
let g:lmap.c.c = ['call feedkeys("\<Plug>NERDCommenterComment")','Comment']
let g:lmap.c[' '] = ['call feedkeys("\<Plug>NERDCommenterToggle")','Toggle']
" The Descriptions for other mappings defined by NerdCommenter, will default
" to their respective commands.

" Leader + timeoutlen opens the main menu
nnoremap <silent> <leader> :LeaderGuide g:lmap<CR>
vnoremap <silent> <leader> :LeaderGuideVisual g:lmap<CR>

" Populate the Dictionary depending on your <leader> key:
call leaderGuide#PopulateDictionary("<Space>", "g:lmap")
" call leaderGuide#PopulateDictionary(",", "g:lmap")
" You might want to call this later, after all mappings are set.
" Alternatively use the following line to rescan the mappings
" whenever the Guide pops up:
autocmd FileType leaderGuide call leaderGuide#PopulateDictionary("<Space>", "g:lmap")



" Another Map for the localleader-prefix:
let g:anotherdict = {}
nnoremap <silent> <localleader> :LeaderGuide g:anotherdict<CR>
vnoremap <silent> <localleader> :LeaderGuideVisual g:anotherdict<CR>

" No renaming and descriptions, just get the mappings:
call leaderGuide#PopulateDictionary(",", "g:anotherdict")
" As above, make sure to call this after all mappings are set,
" e.g after loading a filetype plugin.
```

Try pressing leader.
The top-level will pop up depending on you timeoutlen setting, awaiting further keystrokes.

Alternatively press leader-f. Assuming leader-f is not mapped otherwise you will end up in the file menu.

Please note that no matter which mappings and menus you configure, your original leader mappings will remain unaffected.
The key guide is an additional layer. It will only activate, when you do not complete your input during the timeoutlen duration.


## Special keys and Mappings

```vim
" Special key mapping.
" Use <C-I> to map the Tab key
let g:lmap.g = {
				\'<C-I>' : ['Gstatus', 'Git Status'],
                \'<BS>'  : ['Gpull',   'Git Pull'],
                \'<C-P>' : ['Gpush',   'Git Push'],
                \'/'     : ['Gcommit', 'Git Commit'],
                \'<F4>'  : ['Gwrite',  'Git Write'],
                \' '     : ['ThisIsSpace',  'SomeDescription'],
                \}

" Call other mappings ( Trigger with <leader>, ):
let g:lmap[','] = ['call feedkeys("\<Plug>(easymotion-prefix)")', 'EasyMotion Prefix']
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

## TODO and Ideas

- Documentation
- Support for vim's buildin mappings?
