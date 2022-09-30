#!/bin/bash

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

install_bins() {
  pip3 install cmakelang
}
install_links() {
  LINKS=(
    ".vim/ftplugin/cmake.vim"
  )
  create_home_links "$LINKS"
}
