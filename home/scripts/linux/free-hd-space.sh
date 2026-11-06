#!/bin/sh

rm -rf $HOME/.local/share/Trash/*
rm -rf $HOME/.cache/*
rm -rf /var/lib/systemd/coredump/*

# haskell cabal download cache
rm -rf ~/.cabal/packages/*
ghcup gc --cache --tmpdirs --unset --profiling-libs --share-dir --hls-no-ghc
rm -rf ~/.ghcup/logs/*

# npm
npm cache clean --force
rm -rf ~/.npm/_npx ~/.npm/_logs

podman volume prune -af
podman image prune -af --build-cache

sudo pacman -Scc
sudo paru -Scc
sudo paru --clean
