#!/bin/bash

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

install_via_pkg_mng xorg-server
install_via_pkg_mng xorg-xinit

LINKS=(
  ".xinitrc"
  ".Xresources"
  ".xserverrc"
)

create_home_links "$LINKS"
