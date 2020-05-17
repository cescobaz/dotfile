let b:ale_fixers = ['prettier']

map <C-x><C-m> :s/\(\S\)/\/* \1 *\//<CR> :noh<CR>
map <C-x><C-a> :s/\/\*(.*)\*\//\1/<CR> :noh<CR>
