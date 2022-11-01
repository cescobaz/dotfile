#!/bin/bash

install_bins() {
  DEST=$HOME/.elixir-ls
  clone_or_pull https://github.com/JakeBecker/elixir-ls.git "$DEST"
  cd "$DEST"
  mix deps.get
  mix compile
  mix elixir_ls.release
  cd "$REF"
}
install_links() {
  LINKS=(
    ".vim/ftplugin/elixir.vim"
  )
  create_home_links "$LINKS"
}
