#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

install_via_pkg_mng xdo
install_aur xtitle
install_aur sutils-git
install_via_pkg_mng bspwm 
install_via_pkg_mng sxhkd 
install_aur lemonbar-git

LINKS=(
  ".config/bspwm"
  ".config/sxhkd"
  ".config/lemonbar"
)

create_home_links "$LINKS"

echo "[INFO] installing global shell vars ..."
echo 'export PANEL_FIFO="/tmp/panel-fifo"' | sudo tee -a /etc/profile

echo "[INFO] installing shell vars ..."
echo 'export PATH=$PATH:$HOME/.config/lemonbar >> $HOME/.custom_env

