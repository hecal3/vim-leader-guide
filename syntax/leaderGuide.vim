
if exists("b:current_syntax")
  finish
endif
syn match guideKey /\[[^\[\]]*\]/hs=s+1,he=e-1
syn match guideDesc / [^\[\]]*[ |\n]/hs=s+1,me=e-1

let b:current_syntax = "leaderguide"
hi def link guideKey Type
hi def link guideDesc Identifier
