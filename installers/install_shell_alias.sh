#!/bin/bash

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

LINKS=(
  ".aliases"
)
create_home_links "$LINKS"

echo 'test -e ~/.aliases && source ~/.aliases || true' >> ~/.zshrc
