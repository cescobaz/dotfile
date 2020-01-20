#!/bin/bash

clone_or_pull() {
  URL=$1
  DESTINATION=$2
  if [ -e "$DESTINATION" ]; then
    cd "$DESTINATION"
    git pull
    cd "$REF"
  else
    git clone "$URL" "$DESTINATION"
  fi
}
