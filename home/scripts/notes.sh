#!/bin/sh

if [ -z ${NOTES_DIR+x} ]; then
  NOTES_DIR="$HOME/notes"
fi

mkdir -p $NOTES_DIR
cd $NOTES_DIR
$HOME/scripts/vim.sh
