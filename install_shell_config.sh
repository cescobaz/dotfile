#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

LINKS=(
  ".shell_env"
  ".aliases"
  ".ripgrep"
)

create_home_links "$LINKS"
