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

make_link() {
  LINK_DIR=$(realpath $(dirname $2))
  mkdir -p $LINK_DIR
  ln -s $1 $2
}

SCRIPT_HOME=$(realpath $(dirname $0))/home
DHOME="$HOME"

create_home_link() {
  REAL_FILE="$SCRIPT_HOME/$1"
  SLINK="$DHOME/$1"
  echo "[INFO] installing link \"${SLINK}\" that points to \"${REAL_FILE}\""
  if [ ! -e "$SLINK" ] && [ ! -L "$SLINK" ] || [ "$ALL" == 1 ]; then
    rm -r "$SLINK"
    make_link "$REAL_FILE" "$SLINK"
    return
  fi
  while true; do
    echo ""
    echo "File at ${SLINK} exists, do you want to override it? (y/n/a)"
    read RESPONSE
    if [ $RESPONSE == "a" ]; then
      RESPONSE="y"
      ALL=1
    fi
    if [ $RESPONSE == "y" ]; then
      rm -r "$SLINK"
      make_link "$REAL_FILE" "$SLINK"
      break
    elif [ $RESPONSE == "n" ]; then
      break
    else
      "Answer "y", "a" or "n" please"
    fi
  done
}

create_home_links() {
  LINKS=$1
  for LINK in "${LINKS[@]}"; do
    create_home_link "$LINK"
  done
}
