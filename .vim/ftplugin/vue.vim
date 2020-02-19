let b:ale_fixers = ['prettier']
let b:ale_linters = ['vls']

map <C-x><C-m> :s/^/\/\/ /<CR> :noh<CR>
map <C-x><C-a> :s/^\( *\)\/\/ /\1/<CR> :noh<CR>
