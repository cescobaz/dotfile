#!/bin/bash

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

install_bins() {
  sudo port install ccls-clang-11

  ln -s /opt/local/bin/clang-mp-11 /Users/cescobaz/.local/bin/clang
  ln -s /opt/local/bin/clang-format-mp-11 /Users/cescobaz/.local/bin/clang-format
}

install_links() {
  LINKS=(
    ".vim/ftplugin/c.vim"
  )

  create_home_links "$LINKS"
}

if [ "$1" == "--only-links" ]; then
  install_links
else
  install_bins
  install_links
fi
