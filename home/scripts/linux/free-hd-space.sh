#!/bin/sh

rm -rf $HOME/.local/share/Trash/*

podman image prune --all
