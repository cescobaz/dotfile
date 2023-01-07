#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

brew list zsh-syntax-highlighting || brew install zsh-syntax-highlighting
echo "[INFO] installing zsh-autosuggestions"
clone_or_pull https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
echo "[INFO] installing zsh-nvm"
clone_or_pull https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm
echo "[INFO] creating .zsh_functions directory"
mkdir -p ~/.zsh_functions
