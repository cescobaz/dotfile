#!/bin/sh

rm -rf $HOME/.local/share/Trash/*
rm -rf /var/lib/systemd/coredump/*

podman image prune --all
sudo pacman -Scc
sudo paru -Sc
sudo paru --clean
