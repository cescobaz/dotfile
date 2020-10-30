#!/bin/sh

set -e

PACKAGE=$1

cd "$HOME/aur/$PACKAGE"

git clean -f -d

git pull

makepkg -si
