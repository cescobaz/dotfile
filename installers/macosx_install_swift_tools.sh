#!/bin/bash

install_bins() {
  brew list swiftformat || brew install swiftformat
}

install_links() {
  LINKS=(
    ".vim/ftplugin/swift.vim"
  )

  create_home_links "$LINKS"
}

if [ "$1" == "--only-links" ]; then
  install_links
else
  install_bins
  install_links
fi
