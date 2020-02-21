#!/bin/bash

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

echo "[INFO] installing tmux config"

DEST=.tmux-conf
cd
clone_or_pull https://github.com/gpakosz/.tmux.git $DEST
ln -s -f $DEST/.tmux.conf

cd "$REF"
