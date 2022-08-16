let b:ale_fixers = ['mix_format']
let b:ale_linters = ['elixir-ls']
let b:ale_elixir_elixir_ls_release = $HOME.'/.elixir-ls/release'
" let b:ale_completion_excluded_words = ['defmodule', '$0', '$1', '$2', '$3', '$4' ]

map <C-x><C-m> :s/^\( *\)\(.\)/\1# \2/<CR> :noh<CR>
map <C-x><C-a> :s/\( *\)# *\(.\)/\1\2/<CR> :noh<CR>
