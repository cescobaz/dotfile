#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

install_via_pkg_mng alacritty

LINKS=(
  ".config/alacritty"
)

create_home_links "$LINKS"
