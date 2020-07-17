#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

install_bins() {
  install_via_pkg_mng termite
}

install_links() {
  LINKS=(
    ".config/termite"
  )
  create_home_links "$LINKS"
}

if [ "$1" == "--only-links" ]; then
  install_links
else
  install_bins
  install_links
fi
