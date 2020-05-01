#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

install_bins() {
  clone_or_pull 'https://github.com/zsh-users/zsh-autosuggestions' "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  clone_or_pull 'https://github.com/zsh-users/zsh-syntax-highlighting.git' "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
}

install_links() {
  LINKS=(
    ".zshrc"
    ".shell_env"
    ".aliases"
    ".ripgrep"
    ".zsh_custom"
  )

  create_home_links "$LINKS"
}

if [ "$1" == "--only-links" ]; then
  install_links
else
  install_bins
  install_links
fi
