#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

install_bin() {
  pip install black
  pip install mypy
  pip install python-language-server
}

install_links() {
  LINKS=(
    ".vim/ftplugin/python.vim"
  )
  create_home_links "$LINKS"
}

if [ "$1" == "--only-links" ]; then
  install_links
else
  install_bins
  install_links
fi
