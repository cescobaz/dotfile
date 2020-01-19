#!/bin/bash

set -e

REF=$(realpath $(dirname $0))

PACKAGES=(
  coreutils
  fd
  ripgrep
  macvim
  cmake
  zsh-syntax-highlighting
  shfmt
  ktlint
  yamllint
)

echo "[QUESTION] install brew packages? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  for PACKAGE in "${PACKAGES[@]}"; do
    echo "[INFO] installing $PACKAGE ..."
    brew list "$PACKAGE" || brew install "$PACKAGE"
  done
fi

echo "[QUESTION] install zsh-autosuggestionsi? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing zsh-autosuggestions"
  DESTINATION=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  if [ -e "$DESTINATION" ]; then
    cd "$DESTINATION"
    git pull
    cd "$REF"
  else
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  fi
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
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "[QUESTION] install npm prettier? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing npm prettier"
  npm i -g prettier
fi

echo "[QUESTION] install tsserver? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing tsserver"
  npm install -g typescript
fi

echo "[QUESTION] install haskell tools? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing haskell tools"
  ./macosx_install_haskell_tools.sh
fi

echo "[QUESTION] install bash-language-server? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing bash-language-server"
  npm i -g bash-language-server
fi

echo "[QUESTION] install php tools? (y/n)"
read ANSWER
if [ $ANSWER == "y" ]; then
  echo "[INFO] installing php tools"
  ./macosx_install_php_tools.sh
fi
