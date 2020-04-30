#!/bin/bash

install_via_pkg_mng_2() {
  PACMAN_PACKAGE=$1
  BREW_PACKAGE=$2
  brew list $BREW_PACKAGE || brew install $BREW_PACKAGE
  if [ "$?" != 0 ]; then
    sudo pacman -S $PACMAN_PACKAGE
  fi
  if [ "$?" != 0 ]; then
    echo "unable to install $BREW_PACKAGE or $PACMAN_PACKAGE via package manager"
    exit 1
  fi
}

install_via_pkg_mng() {
  install_via_pkg_mng_2 $1 $1
}

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

AURHOME="$HOME/aur"

install_aur() {
  PACKAGE=$1
  mkdir -p "$AURHOME"
  PWD=$(pwd)
  cd "$AURHOME"
  clone_or_pull "https://aur.archlinux.org/$PACKAGE.git"
  cd "$PACKAGE"
  makepkg -si
  cd "$PWD"
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
    rm -fr "$SLINK"
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

if [ "$#" -ne 0 ] && [ "$1" == "call" ]; then
  shift
  COMMAND=$1
  shift
  eval "$COMMAND" "$@"
fi
