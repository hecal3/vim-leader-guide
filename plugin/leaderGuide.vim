if !exists('g:leaderGuide_use_buffer')
	let g:leaderGuide_use_buffer = 1
endif

if !exists('g:leaderGuide_vertical')
	let g:leaderGuide_vertical = 0
endif

if !exists('g:leaderGuide_position')
	let g:leaderGuide_position = 'botright'
endif

command! -nargs=1 LeaderGuide call leaderGuide#Start(<args>)
