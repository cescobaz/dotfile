#!/bin/bash

set -e

echo 'iterm2 ...'
cp -R ~/.iterm2 ./

echo '.vim ...'
cp ~/.vim/vimrc ./.vim/vimrc

echo '.p ...'
cp -R ~/.p ./

echo '.zshrc ...'
cp ~/.zshrc ./

