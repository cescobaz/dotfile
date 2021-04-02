#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

PACKAGES=(
  coreutils
  cmake
  fd
  ripgrep
  tmux
  fswatch
  yamllint
  exa
)
