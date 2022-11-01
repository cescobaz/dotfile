#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

install_bins() {
  npm install --global prettier
}

install_links() {
  LINKS=(
    ".vim/ftplugin/css.vim"
  )
  create_home_links "$LINKS"
}

if [ "$1" == "--only-links" ]; then
  install_links
else
  install_bins
  install_links
fi
