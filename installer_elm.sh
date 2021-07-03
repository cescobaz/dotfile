#!/bin/bash

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

install_bins() {
  nix-env -i elm
  npm install -g @elm-tooling/elm-language-server
  nix-env -i elm-format
}
install_links() {
  LINKS=(
    ".vim/ftplugin/elm.vim"
  )
  create_home_links "$LINKS"
}
