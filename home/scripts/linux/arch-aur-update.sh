#!/bin/sh

set -e

PACKAGE=$1

cd "$HOME/aur/$PACKAGE"

git clean -f **/*
git reset --hard
git pull

makepkg -si
