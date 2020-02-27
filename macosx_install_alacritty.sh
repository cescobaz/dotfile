#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

brew cask list alacritty || brew cask install alacritty
clone_or_pull https://github.com/alacritty/alacritty.git ./alacritty

echo "[INFO] installing manual page"
sudo mkdir -p /usr/local/share/man/man1
gzip -c alacritty/extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null

echo "[INFO] installing zsh completions"
cp alacritty/extra/completions/_alacritty ~/.zsh_functions/_alacritty

echo "[INFO] installing Terminfo"
sudo tic -xe alacritty,alacritty-direct alacritty/extra/alacritty.info

echo "[INFO] cleanup"
rm -rf ./alacritty

cd "$REF"
