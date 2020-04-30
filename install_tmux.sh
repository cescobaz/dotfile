#!/bin/bash

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

brew install tmux
if [ "$?" != 0 ]; then
  sudo pacman -S tmux
fi
if [ "$?" != 0 ]; then
  echo "unable to install tmux via package manager"
  exit 1
fi

LINKS=(
  ".tmux.conf"
  ".config/base16-tmux.conf"
)

create_home_links "$LINKS"
