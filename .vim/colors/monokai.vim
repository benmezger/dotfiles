"
" Monokai VIM by ka0sm (www.ka0sm.tumblr.com)
" 
" Vim port of the Monokai theme for TextMate originally created by Wimer Hazenberg.
" Original by Tomas Restrepo at vim.org script id = 2340
"

" Cursor adn Normal
hi normal			ctermfg=white	ctermbg=black
hi Cursor			ctermfg=white	ctermbg=white

" C Ansi Functions, called functions, declared functions
hi cAnsiFunction			ctermfg=208
hi cUserFunctionDeclared 	ctermfg=green
hi cUserFunctionCalled 		ctermfg=cyan

" C Ansi highlight
hi keyword			ctermfg=magenta
hi Statement		ctermfg=magenta
hi StorageClass		ctermfg=magenta
hi PreCondit		ctermfg=red
hi PreProc			ctermfg=red
hi Repeat			ctermfg=magenta
hi Conditional		ctermfg=magenta
hi Constant			ctermfg=blue
hi Character		ctermfg=blue
hi String			ctermfg=yellow
hi number			ctermfg=blue
hi Float			ctermfg=cyan
hi Type				ctermfg=cyan
hi Operator			ctermfg=magenta
hi cOperators		ctermfg=white
hi Boolean			ctermfg=blue
hi Typedef			ctermfg=cyan
hi Structure		ctermfg=cyan
hi SpecialChar		ctermfg=blue
hi Delimiter		ctermfg=white
hi SpecialComment	ctermfg=black	cterm=bold
hi Special			ctermfg=magenta	cterm=bold
hi SpecialKey		ctermfg=magenta
hi MatchParen		ctermfg=black	ctermbg=yellow
hi Comment			ctermfg=black	cterm=bold
hi Macro			ctermfg=green
hi Define			ctermfg=green
hi Debug			ctermfg=225
hi DiffAdd			ctermbg=red
hi DiffChange		ctermfg=white	ctermbg=239
hi DiffDelete		ctermfg=162		ctermbg=53
hi DiffText			ctermbg=magenta
hi Error			ctermfg=white	ctermbg=196 
hi ErrorMsg			ctermfg=15		ctermbg=196
hi Directory		ctermfg=118
hi Identifier		ctermfg=green
hi Ignore			ctermfg=white	ctermbg=232
hi Label			ctermfg=red
hi ModeMsg			ctermfg=228		cterm=bold
hi MoreMsg			ctermfg=228
hi Exception		ctermfg=yellow

" Complete menu
hi Pmenu			ctermfg=cyan	ctermbg=16
hi PmenuSel			ctermfg=cyan	ctermbg=244
hi PmenuSbar		ctermbg=232
hi PmenuThumb		ctermfg=cyan
hi Question			ctermfg=11
hi Search			ctermfg=235 ctermbg=yellow 

" Marks and columns
hi Underlined		ctermfg=244		cterm=underline
hi SignColumn		ctermfg=118		ctermbg=234
hi StatusLine		ctermfg=235		ctermbg=102
hi StatusLineNC		ctermfg=235		ctermbg=102
hi Tag				ctermfg=white
hi Title			ctermfg=yellow
hi Todo				ctermfg=231		ctermbg=232
hi VertSplit		ctermfg=black	cterm=bold ctermbg=102
hi VisualNOS		ctermbg=11
hi Visual			ctermbg=236
hi WarningMsg		ctermfg=231		ctermbg=238
hi WildMenu			ctermfg=cyan	ctermbg=16
hi CursorColumn		ctermbg=white
hi ColorColumn		ctermbg=234
hi LineNr			ctermfg=238
hi NonText			ctermfg=59

