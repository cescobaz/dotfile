#!/bin/bash

set -e

brew install fd
brew install ripgrep
brew install macvim
brew install cmake

brew install zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
