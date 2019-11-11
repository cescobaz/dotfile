#!/bin/bash

set -e

echo 'iterm2 ...'
cp -R ./.iterm2 ~/

echo '.vim ...'
cp -R ./.vim ~/

echo '.p ...'
cp -R ./.p ~/

echo '.zshrc ...'
cp ./.zshrc ~/

# add env variabiles to env file .zshenv
echo 'adding env var to .zshenv ...'
echo 'source ~/.p/env' >> ~/.zshenv

echo 'Remeber to open vim and run :PlugInstall, then restart vim'
