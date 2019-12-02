#!/bin/bash

set -e

PACKAGES=(
  coreutils
  fd
  ripgrep
  macvim
  cmake
  zsh-syntax-highlighting
  shfmt
  ktlint
)

for PACKAGE in "${PACKAGES[@]}"; do
  echo "[INFO] installing $PACKAGE ..."
  brew list "$PACKAGE" || brew install "$PACKAGE"
done

echo "[INFO] installing zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "[INFO] installing tmux plugin manager"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "[INFO] installing npm prettier"
npm i -g prettier

echo "[INFO] installing haskell tools ..."
./macosx_install_haskell_tools.sh

echo "[INFO] installing bash-language-server"
npm i -g bash-language-server
