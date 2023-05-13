#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

export BASE16_SHELL="$HOME/.config/base16-shell"

clone_or_pull https://github.com/chriskempson/base16-shell.git $BASE16_SHELL

cat $REF/install_base16.rc >> $HOME/.zshrc
cat $REF/install_base16.rc >> $HOME/.bashrc

bash ~/.config/base16-shell/scripts/base16-classic-dark.sh

# pip3 install base16-shell-preview
