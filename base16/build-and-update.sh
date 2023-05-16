#!/bin/bash

dir=$(dirname $(realpath $0))

builder_dir="$dir/builder"
build_dir="$dir/_build"

mkdir -p "$builder_dir"
cd "$builder_dir"
pybase16 update
# '-t neovim' points to a not updated (and not working for me because of require('vim')) repo
pybase16 build -t shell -t nvim -t vim -o "$build_dir"

echo "Copying to base16-shell"
cp "$build_dir/shell/scripts/*" $HOME/.config/base16-shell/scripts/

echo "Copying to vim"
rm -r $HOME/.vim/colors
cp -r "$build_dir/vim/colors" $HOME/.vim/colors

echo "Copying to neovim"
rm -r $HOME/.config/nvim/colors
cp -r "$build_dir/nvim/colors" $HOME/.config/nvim/colors
