#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 SOURCE_FILE [OPTIONS]"
  echo "OPTIONS: --only-links --only-bins"
  exit 1
fi

source "$1"

if [ "$2" == "--only-links" ]; then
  install_links
elif [ "$2" == "--only-bins" ]; then
  install_bins
else
  install_bins
  install_links
fi
