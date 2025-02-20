#!/bin/sh

rm -rf $HOME/.local/share/Trash/*
rm -rf $HOME/.cache/*
rm -rf /var/lib/systemd/coredump/*

podman image prune --all
sudo pacman -Scc
sudo paru -Scc
sudo paru --clean
