noremap j gj
noremap k gk
noremap gj j
noremap gk k

nmap J mzJ`z
map <C-d> 18jzz
map <C-u> 18kzz
map n nzz
map N Nzz

exmap back obcommand app:go-back
exmap forward obcommand app:go-forward

nmap L :forward<CR>
nmap H :back<CR>

set clipboard=unnamed

exmap surround_wiki surround [[ ]]
exmap surround_double_quotes surround " "
exmap surround_single_quotes surround ' '
exmap surround_backticks surround ` `
exmap surround_brackets surround ( )
exmap surround_square_brackets surround [ ]
exmap surround_curly_brackets surround { }

map gsa" :surround_double_quotes<CR>
map gsa' :surround_single_quotes<CR>
map gsa` :surround_backticks<CR>
map gsab :surround_brackets<CR>
map gsa( :surround_brackets<CR>
map gsa) :surround_brackets<CR>
map gsa[ :surround_square_brackets<CR>
map gsa] :surround_square_brackets<CR>
map gsa{ :surround_curly_brackets<CR>
map gsa} :surround_curly_brackets<CR>

exmap togglefold obcommand editor:toggle-fold
nmap zo :togglefold<CR>
nmap zc :togglefold<CR>
nmap za :togglefold<CR>
