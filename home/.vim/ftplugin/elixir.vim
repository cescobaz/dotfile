let b:ale_fixers = ['mix_format']
let b:ale_linters = ['elixir-ls']
let b:ale_elixir_elixir_ls_release = $HOME.'/.elixir-ls/release'

map <C-x><C-m> :s/^\( *\)\(.\)/\1# \2/<CR> :noh<CR>
map <C-x><C-a> :s/\( *\)# *\(.\)/\1\2/<CR> :noh<CR>
