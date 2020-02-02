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
  macvim
  zsh-syntax-highlighting
  yamllint
  fswatch
)

echo "[QUESTION] install brew packages? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  for PACKAGE in "${PACKAGES[@]}"; do
    echo "[INFO] installing $PACKAGE ..."
    brew list "$PACKAGE" || brew install "$PACKAGE"
  done
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

echo "[QUESTION] install zsh-autosuggestionsi? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing zsh-autosuggestions"
  clone_or_pull https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

echo "[QUESTION] install pynvim? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing pynvim"
  pip3 install --user pynvim
fi

echo "[QUESTION] install tmux plugin manager? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing tmux plugin manager"
  clone_or_pull https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "[QUESTION] install npm prettier? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing npm prettier"
  npm i -g prettier
fi

echo "[QUESTION] install shell tools? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing shell tools"
  "$REF/macosx_install_shell_tools.sh"
fi

echo "[QUESTION] install tsserver? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing tsserver"
  npm install -g typescript
fi

echo "[QUESTION] install vue-language-server? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing vue-language-server"
  npm install vue-language-server -g
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
