#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

LINKS=(
  ".shell_env"
  ".aliases"
  ".ripgrep"
  ".zsh_custom"
)

create_home_links "$LINKS"
