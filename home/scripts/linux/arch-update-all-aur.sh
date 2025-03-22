#!/bin/sh

set -e

SCRIPT_DIR=$(realpath $(dirname $0))
UPDATE_AUR_SCRIPT="$SCRIPT_DIR/arch-aur-update.sh"

ALL=0

for PACKAGE_PATH in "$HOME/aur"/*; do
  PACKAGE=$(basename $PACKAGE_PATH)
  while true; do
    if [ $ALL != 1 ]; then
      echo "[QUESTION} do you want to update $PACKAGE? (y/n/a)"
      read RESPONSE
    fi
    if [ $RESPONSE == "a" ]; then
      RESPONSE="y"
      ALL=1
    fi
    if [ $RESPONSE == "y" ]; then
      echo "[INFO] installing $PACKAGE ..."
      $UPDATE_AUR_SCRIPT $PACKAGE
      break
    elif [ $RESPONSE == "n" ]; then
      break
    else
      "Answer "y", "a" or "n" please"
    fi
  done
done
