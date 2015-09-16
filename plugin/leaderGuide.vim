if !exists('g:leaderGuide_use_buffer')
	let g:leaderGuide_use_buffer = 1
endif

if !exists('g:leaderGuide_vertical')
	let g:leaderGuide_vertical = 0
endif

if !exists('g:leaderGuide_position')
	let g:leaderGuide_position = 'botright'
endif

if !exists('ifleaderGuide_run_map_on_popup')
	let g:leaderGuide_run_map_on_popup = 1
endif

command! -nargs=1 LeaderGuideD call leaderGuide#start('0', <args>)
command! -range -nargs=1 LeaderGuideVisualD call leaderGuide#start('1', <args>)

command! -nargs=1 LeaderGuide call leaderGuide#start_by_prefix('0', <args>)
command! -range -nargs=1 LeaderGuideVisual call leaderGuide#start_by_prefix('1', <args>)
