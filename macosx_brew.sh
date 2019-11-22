#!/bin/bash

set -e

PACKAGES=(
  coreutils
  fd
  ripgrep
  macvim
  cmake
  zsh-syntax-highlighting
)

for PACKAGE in "${PACKAGES[@]}"
do
   echo "[INFO] installing $PACKAGE ..."
   brew list "$PACKAGE" || brew install "$PACKAGE"
done

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
