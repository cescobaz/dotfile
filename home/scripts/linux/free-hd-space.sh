#!/bin/sh

rm -rf $HOME/.local/share/Trash/*
podman image prune --all
sudo pacman -Scc
sudo paru -Sc
sudo paru --clean
