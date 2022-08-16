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
    ".config/nvim/init.vim"
    ".vim/UltiSnips"
    ".vim/ftplugin/c.vim"
    ".vim/ftplugin/elixir.vim"
    ".vim/ftplugin/elm.vim"
    ".vim/ftplugin/haskell.vim"
    ".vim/ftplugin/javascript.vim"
    ".vim/ftplugin/json.vim"
    ".vim/ftplugin/kotlin.vim"
    ".vim/ftplugin/nix.vim"
    ".vim/ftplugin/php.vim"
    ".vim/ftplugin/python.vim"
    ".vim/ftplugin/sh.vim"
    ".vim/ftplugin/swift.vim"
    ".vim/ftplugin/vlang.vim"
    ".vim/ftplugin/vue.vim"
    ".vim/ftplugin/yaml.vim"
  )

  create_home_links "$LINKS"
}

if [ "$1" == "--only-links" ]; then
  install_links
else
  install_bins
  install_links
fi
