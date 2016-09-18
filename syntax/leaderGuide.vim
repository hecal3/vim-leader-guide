if exists("b:current_syntax")
    finish
endif
let b:current_syntax = "leaderguide"

syn match guideDesc /.*$/
syn region guideKey start="\["hs=e+1 end="\]\s"he=s-1 contained
syn region guideBrackets start="^\s*\[" end="\]\s\+" contains=guideKey keepend

hi def link guideDesc Identifier
hi def link guideKey Type
hi def link guideBrackets Delimiter
