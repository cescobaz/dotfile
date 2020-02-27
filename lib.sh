#!/bin/bash

clone_or_pull() {
  URL=$1
  DESTINATION=$2
  if [ -e "$DESTINATION" ]; then
    REF=$(pwd)
    cd "$DESTINATION"
    git pull
    cd "$REF"
  elif [ -z ${DESTINATION:-''} ]; then
    git clone "$URL"
  else
    git clone "$URL" "$DESTINATION"
  fi
}
