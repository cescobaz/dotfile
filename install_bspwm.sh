#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

install_via_pkg_mng xdo
install_aur xtitle
install_aur sutils-git
install_via_pkg_mng feh
install_via_pkg_mng xorg-xsetroot
install_via_pkg_mng bspwm
install_via_pkg_mng sxhkd
install_aur lemonbar-xft-git

LINKS=(
  ".config/bspwm"
  ".config/sxhkd"
  ".config/lemonbar"
)

create_home_links "$LINKS"

echo "[INFO] installing global shell vars in /etc/profile ..."
echo "
# bspwm panel settings
PANEL_FIFO=/tmp/panel-fifo
PANEL_HEIGHT=32
PANEL_FONT=\"SourceCodePro:size=9\"
PANEL_WM_NAME=bspwm_panel
export PANEL_FIFO PANEL_HEIGHT PANEL_FONT PANEL_WM_NAME
# end bspwm panel settings" | sudo tee -a /etc/profile 

echo "[INFO] installing shell vars ..."
echo 'export PATH=$PATH:$HOME/.config/lemonbar >> $HOME/.custom_env

