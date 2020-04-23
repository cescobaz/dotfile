#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

install_via_pkg_mng bspwm 
install_via_pkg_mng sxhkd 

LINKS=(
  ".config/bspwm"
  ".config/sxhkd"
)

create_home_links "$LINKS"
