let b:ale_fixers = ['floskell']
let b:ale_linters = ['hie']

map <C-x><C-m> :s/\(\S\)/-- \1/<CR> :noh<CR>
map <C-x><C-a> :s/-- \(\S\)/\1/<CR> :noh<CR>
