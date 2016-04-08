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

" Provide commands and descriptions for existing mappings
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
" Define some descriptions
let g:lmap.c.c = ['call feedkeys("\<Plug>NERDCommenterComment")','Comment']
let g:lmap.c[' '] = ['call feedkeys("\<Plug>NERDCommenterToggle")','Toggle']
" The Descriptions for other mappings defined by NerdCommenter, will default
" to their respective commands.

```

There are two ways to call the plugin:

Recommended:
Register the description dictionary for the prefix
(assuming Space is your leader):

```vim
call leaderGuide#register_prefix_descriptions("<Space>", "g:lmap")
nnoremap <silent> <leader> :LeaderGuide '<Space>'<CR>
vnoremap <silent> <leader> :LeaderGuideVisual '<Space>'<CR>
```

The guide will be up to date at all times.
Native vim mappings will always take 
precedence over dictionary-only mappings (e.g. the git menu above)

---

Not Recommended:
Call by providing a dictionary directly.
When the mappings change, the guide will not update itself

```vim
nnoremap <silent> <leader> :LeaderGuideD g:lmap<CR>
vnoremap <silent> <leader> :LeaderGuideVisualD g:lmap<CR>
"" Get all <Space> mappings into the dictionary:
"call leaderGuide#populate_dictionary("<Space>", "g:lmap")
```

---


It is possible to call the guide for keys other than `leader`:

```vim
nnoremap <localleader> :LeaderGuide  ','<CR>
vnoremap <localleader> :LeaderGuideVisual  ','<CR>
" This variant won't habe any group names.

" Group names can be defined by filetype. Add the following lines:
let g:llmap = {}
autocmd FileType tex let g:llmap.l = { 'name' : 'vimtex' }
call leaderGuide#register_prefix_descriptions(",", "g:llmap")
" to name the <localleader>-n group vimtex in tex files.


```

Note that, as shown in the example above, a description dictionary is not necessary.
All mappings will be displayed regardless.
The dictionary configuration is necessary however, to provide group names or a description text.

After pressing `leader` the guide buffer will pop up when there are no further keystrokes within `timeoutlen`.

Pressing other keys within `timeoutlen` will either complete the mapping or open a subgroup.
In the example above `leader-f` will open up the file menu.

Please note that no matter which mappings and menus you configure, your original leader mappings will remain unaffected.
The key guide is an additional layer. It will only activate, when you do not complete your input during the timeoutlen duration.


## Display mappings without prefix:

Additionally it is possible to display all buffer local mappings with `:LeaderGuide '<buffer>'`.

This feature is useful to explore mappings defined by plugins in their respecive buffers. (fugitive, tagbar, vimfiler, Nerdtree, etc.)
To make the usage of `LeaderGuide '<buffer>'` in those plugin buffers more convenient one can make use of autocommands.

Examples:

```vim
autocmd FileType gitcommit  noremap <buffer> <leader> :LeaderGuide '<buffer>'<CR>
" for fugitive

autocmd BufEnter __Tagbar__  noremap <buffer> <leader> :LeaderGuide '<buffer>'<CR>
" for tagbar
```


To open a guide with all mappings use `:LeaderGuide '  '`.


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

Minimum vertical space between columns:

```vim
let g:leaderGuide_vspace = 5
```

Don't update the guide automatically: (Not recommended)

```vim
let g:leaderGuide_run_map_on_popup = 0
```

The update is almost instantaneous and will only run when the guide
actually pops up. Apart from that the automatic update has no performance impact.

## TODO and Ideas

- Documentation
- Support for vim's buildin mappings?
