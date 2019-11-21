#!/bin/bash

make_link() {
  LINK_DIR=$(realpath $(dirname $2))
  mkdir -p $LINK_DIR
  ln -s $1 $2
}

SCRIPT_HOME=$(realpath $(dirname $0))
DHOME="$HOME"

LINKS=(
  "$SCRIPT_HOME/.zshrc:$DHOME/.zshrc"
  "$SCRIPT_HOME/.p:$DHOME/.p"
  "$SCRIPT_HOME/.vim/vimrc:$DHOME/.vim/vimrc"
  "$SCRIPT_HOME/.tmux.conf:$DHOME/.tmux.conf"
  "$SCRIPT_HOME/.iterm2/com.googlecode.iterm2.plist:$DHOME/.iterm2/com.googlecode.iterm2.plist"
)

for LINK in "${LINKS[@]}"
do
  SLINK="${LINK##*:}"
  REAL_FILE="${LINK%%:*}"
  echo "[INFO] installing link \"${SLINK}\" that points to \"${REAL_FILE}\""
  if [ ! -e "$SLINK" ] && [ ! -L "$SLINK" ]
  then 
   make_link "$REAL_FILE" "$SLINK"
   continue
  fi
  while true; do
    echo "File at ${SLINK} exists, do you want to override it? (y/n)"
    read RESPONSE
    if [ $RESPONSE == "y" ]; then
      rm -r "$SLINK"
      make_link "$REAL_FILE" "$SLINK"
      break
    elif [ $RESPONSE == "n" ]; then
      break
    else
      "Answer "y" or "n" please"
    fi
  done
done
