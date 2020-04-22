let b:ale_fixers = ['ktlint']
let b:ale_linters = [ 'languageserver', 'kotlinc']
let b:ale_kotlin_languageserver_executable = $HOME.'/.kotlin-language-server/server/build/install/server/bin/kotlin-language-server'

let b:ale_kotlin_ktlint_executable = 'ktlint' 
let b:ale_kotlin_ktlint_options = '--experimental'
