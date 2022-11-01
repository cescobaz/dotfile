#!/bin/bash

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

install_bins() {
  DESTINATION="$HOME/.v"
  clone_or_pull 'https://github.com/vlang/v' "$DESTINATION"
  cd "$DESTINATION"
  make
  unlink "$HOME/.local/bin/v"
  ln -s "$DESTINATION/v" "$HOME/.local/bin/v"
  cd "$REF"
}

install_links() {
  LINKS=(
    ".vim/ftplugin/vlang.vim"
  )
  create_home_links "$LINKS"
}

if [ "$1" == "--only-links" ]; then
  install_links
else
  install_bins
  install_links
fi
