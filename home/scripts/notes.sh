#!/bin/sh

NOTES_DIR=${NOTES_DIR:-"$HOME/notes"}

mkdir -p $NOTES_DIR
cd $NOTES_DIR
$HOME/scripts/vim.sh
