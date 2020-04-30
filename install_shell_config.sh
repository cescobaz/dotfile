#!/bin/bash

set -ex

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

LINKS=(
  ".zshrc"
  ".shell_env"
  ".aliases"
  ".ripgrep"
  ".zsh_custom"
)

create_home_links "$LINKS"
