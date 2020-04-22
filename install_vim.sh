#!/bin/bash

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

brew install macvim
if [ "$?" != 0 ]; then
  sudo pacman -S vim
fi
if [ "$?" != 0 ]; then
  echo "unable to install vim via package manager"
  exit 1
fi

echo "[QUESTION] install pynvim? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing pynvim"
  pip3 install msgpack
  pip3 install --user pynvim
fi

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
