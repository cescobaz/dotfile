let b:ale_fixers = ['eslint']
let b:ale_linters = ['eslint', 'tsserver', 'vls']

map <C-x><C-m> :s/^/\/\/ /<CR> :noh<CR>
map <C-x><C-a> :s/^\( *\)\/\/ /\1/<CR> :noh<CR>
