let b:ale_fixers = ['hindent']

map <C-x><C-m> :s/\(\S\)/-- \1/<CR> :noh<CR>
map <C-x><C-a> :s/-- \(\S\)/\1/<CR> :noh<CR>
