# vim-leader-guide

vim-leader-guide is a vim keymap-display loosely inspired by emacs's [guide-key](https://github.com/kai2nenobu/guide-key).

This Plugin is not stable yet. The configuration and commands might change in the future.

![img1.png](https://cloud.githubusercontent.com/assets/11238697/14471215/bbc54a40-00ed-11e6-9eb2-8b6fb247589f.png)


![img3.png](https://cloud.githubusercontent.com/assets/11238697/14471222/c1ded6b2-00ed-11e6-9a01-2aa20753d42e.png)

## Features
    - Show all global mappings
    - Show all buffer-local mappings (for plugins, etc.)
    - Show all mappings following a prefix (<leader>, <localleader>, etc.)
    - Dynamic update on every call
    - Define group names and arbitrary descriptions.
    - No default mappings, no autocomands. Does nothing on it's own.

## Installation

- [Plug](https://github.com/junegunn/vim-plug)
  - `Plug 'hecal3/vim-leader-guide'`

For manual installation copy this repository somewhere and add its path to the vim runtimepath.

## Usage Examples
For a more detailed description of available commands and functions, as well
as some configuration recommendations see the documentation.

The plugin configuration is based on vim's dictionaries.

```vim
" Define prefix dictionary
let g:lmap =  {}

" Second level dictionaries:
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
Note: Depending on your use case extensive dictionary configuration might
not be necessary.

Instead of

```vim
    nmap <silent> <leader>fd :e $MYVIMRC<CR>
    let g:lmap.f.d = ['e $MYVIMRC', 'Open vimrc']
```

one could simply use:

```vim
    nnoremap <Plug>(open-vimrc) :e $MYVIMRC<CR>
    nmap <leader>fd <Plug>(open-vimrc)
```

This variant is a lot less intrusive and just as descriptive as the
dictionary variant above.
This way it is possible use dictionaries for group names only,
and let native vim-mappings handle the rest.

It is also possible to hide the `<Plug>`-prefix and run other arbitrary functions like a custom search/replace or a simple value lookup on the displayname.

Consult the docs under **g:leaderGuide_displayfunc**

-----

To make the guide pop up Register the description dictionary for the prefix first
(assuming Space is your leader):

```vim
call leaderGuide#register_prefix_descriptions("<Space>", "g:lmap")
nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>
```

The guide will be up to date at all times.
Native vim mappings will always take 
precedence over dictionary-only mappings (e.g. the git menu above)

---


It is possible to call the guide for keys other than `leader`:

```vim
nnoremap <localleader> :<c-u>LeaderGuide  ','<CR>
vnoremap <localleader> :<c-u>LeaderGuideVisual  ','<CR>
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

Additionally it is possible to display all buffer local mappings with `<Plug>leaderguide-buffer`.

This feature is useful to explore mappings defined by plugins in their respecive buffers. (fugitive, tagbar, vimfiler, Nerdtree, etc.)
To make the usage of `<Plug>leaderguide-buffer'` in those plugin buffers more convenient one can make use of autocommands.

Examples:

```vim
autocmd FileType gitcommit  noremap <buffer> <leader> <Plug>leaderguide-buffer
" for fugitive

autocmd BufEnter __Tagbar__  noremap <buffer> <leader> <Plug>leaderguide-buffer
" for tagbar
```


To open a guide showing not only the buffer-local but all mappings use `<Plug>leaderguide-global`

To name items on this level, the dictionaries for `leader`, `localleader`, from the examples above, as well as other dictionaries one might have defined, can be combined into a single top-level dictionary:

```vim
let g:topdict = {}
let g:topdict[' '] = g:lmap
let g:topdict[' ']['name'] = '<leader>'
let g:topdict[','] = g:llmap
let g:topdict[',']['name'] = '<localleader>'

call leaderGuide#register_prefix_descriptions("", "g:topd")

" Remove the old prefixes
"call leaderGuide#register_prefix_descriptions(",", "g:llmap")
"call leaderGuide#register_prefix_descriptions("<Space>", "g:lmap")
```

This configuration will provide access to the `leader` and `localleader` spaces when calling with `<Plug>leaderguide-global`

Note: If the user does no configuration on their own the following default is set:

```vim
let g:leaderGuide_map = {}
call leaderGuide#register_prefix_descriptions('', 'g:leaderGuide_map')
```

It's possible to simply reuse this dictionary and enter own configuration.


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

Popup position and orientation:

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

Minimum horizontal space between columns:

```vim
let g:leaderGuide_hspace = 5
```

Don't update the guide automatically: (Not recommended)

```vim
let g:leaderGuide_run_map_on_popup = 0
```

The update is almost instantaneous and will only run when the guide
actually pops up. Apart from that the automatic update has no performance impact.

For the full set of configuration options see the documentation.

## TODO and Ideas

- Support for vim's buildin mappings?
    - Parser for `<C-W>`-mappings?

<!--vim:set et sw=4 ts=4 tw=78:-->
