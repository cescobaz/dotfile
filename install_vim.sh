#!/bin/bash

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

install_bins() {
  install_via_pkg_mng_2 gvim macvim

  echo "[QUESTION] install pynvim? (y/n)"
  read ANSWER
  if [ $ANSWER == "y" ]; then
    echo "[INFO] installing pynvim"
    pip3 install msgpack
    pip3 install --user pynvim
  fi
}

install_links() {
  LINKS=(
    ".vim/vimrc"
    ".vim/UltiSnips"
    ".vim/ftplugin/haskell.vim"
    ".vim/ftplugin/sh.vim"
    ".vim/ftplugin/javascript.vim"
    ".vim/ftplugin/vue.vim"
    ".vim/ftplugin/json.vim"
    ".vim/ftplugin/kotlin.vim"
  )

  create_home_links "$LINKS"
}

if [ "$1" == "--only-links" ]; then
  install_links
else
  install_bins
  install_links
fi
