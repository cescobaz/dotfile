let b:ale_fixers = ['php_cs_fixer']

nmap <C-x><C-m> :s/^/\/\/ /<CR> :noh<CR>
nmap <C-x><C-a> :s/^\( *\)\/\/ /\1/<CR> :noh<CR>
