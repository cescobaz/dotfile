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
  macvim
)

echo "[QUESTION] install brew packages? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  for PACKAGE in "${PACKAGES[@]}"; do
    echo "[INFO] installing $PACKAGE ..."
    brew list "$PACKAGE" || brew install "$PACKAGE"
  done
fi

echo "[QUESTION] install zsh and tools? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing zsh and tools"
  "$REF/macosx_install_zsh_and_tools.sh"
fi

echo "[QUESTION] install fzf? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing fzf"
  brew list fzf || (
    brew install fzf
    $(brew --prefix)/opt/fzf/install
  )
fi

echo "[QUESTION] install pynvim? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing pynvim"
  pip3 install msgpack
  pip3 install --user pynvim
fi

echo "[QUESTION] install shell tools? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing shell tools"
  "$REF/macosx_install_shell_tools.sh"
fi

echo "[QUESTION] install haskell tools? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing haskell tools"
  "$REF/macosx_install_haskell_tools.sh"
fi

echo "[QUESTION] install php tools? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing php tools"
  "$REF/macosx_install_php_tools.sh"
fi

echo "[QUESTION] install elixir tools? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing elixir tools"
  "$REF/macosx_install_elixir_tools.sh"
fi
