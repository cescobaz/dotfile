#!/bin/bash

set -x

brew install fd
brew install ripgrep

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

cd ~/.vim/bundle/YouCompleteMe
python install.sh --ts-completer


# add aliases to .zshrc

# add env variabiles to env file .zshenv

# ask user to open vim and execute command :PlugInstall then restart vim
