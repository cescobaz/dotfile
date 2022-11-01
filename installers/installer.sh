#!/bin/bash

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

if [ $# -lt 2 ]; then
  echo "Usage: $0 SOURCE_FILE OPTIONS"
  echo "OPTIONS: --only-links,-l --only-bins,-b"
  exit 1
fi

source "$1"

if [ "$2" == "--only-links" ] || [ "$2" == "-l" ]; then
  install_links
elif [ "$2" == "--only-bins" ] || [ "$2" == "-b" ]; then
  install_bins
else
  echo "OPTIONS: --only-links,-l --only-bins,-b"
  exit 1
fi
