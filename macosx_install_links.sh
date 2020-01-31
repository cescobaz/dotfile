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
  "$SCRIPT_HOME/.p/vim.sh:$DHOME/.local/bin/v"
  "$SCRIPT_HOME/.gitignore_global:$DHOME/.gitignore_global"
  "$SCRIPT_HOME/.vim/vimrc:$DHOME/.vim/vimrc"
  "$SCRIPT_HOME/.config/yamllint/config:$DHOME/.config/yamllint/config"
  "$SCRIPT_HOME/.vim/ftplugin/yaml.vim:$DHOME/.vim/ftplugin/yaml.vim"
  "$SCRIPT_HOME/.vim/ftplugin/elixir.vim:$DHOME/.vim/ftplugin/elixir.vim"
  "$SCRIPT_HOME/.vim/ftplugin/php.vim:$DHOME/.vim/ftplugin/php.vim"
  "$SCRIPT_HOME/.vim/ftplugin/haskell.vim:$DHOME/.vim/ftplugin/haskell.vim"
  "$SCRIPT_HOME/.vim/ftplugin/swift.vim:$DHOME/.vim/ftplugin/swift.vim"
  "$SCRIPT_HOME/.vim/ftplugin/sh.vim:$DHOME/.vim/ftplugin/sh.vim"
  "$SCRIPT_HOME/.vim/ftplugin/javascript.vim:$DHOME/.vim/ftplugin/javascript.vim"
  "$SCRIPT_HOME/.vim/ftplugin/json.vim:$DHOME/.vim/ftplugin/json.vim"
  "$SCRIPT_HOME/.vim/ftplugin/kotlin.vim:$DHOME/.vim/ftplugin/kotlin.vim"
  "$SCRIPT_HOME/.tmux.conf:$DHOME/.tmux.conf"
  "$SCRIPT_HOME/.iterm2:$DHOME/.iterm2"
  "$SCRIPT_HOME/.stack/config.yaml:$DHOME/.stack/config.yaml"
  "$SCRIPT_HOME/.hindent.yaml:$DHOME/.hindent.yaml"
)

ALL=0

for LINK in "${LINKS[@]}"; do
  SLINK="${LINK##*:}"
  REAL_FILE="${LINK%%:*}"
  echo "[INFO] installing link \"${SLINK}\" that points to \"${REAL_FILE}\""
  if [ ! -e "$SLINK" ] && [ ! -L "$SLINK" ] || [ $ALL == 1 ]; then
    rm -r "$SLINK"
    make_link "$REAL_FILE" "$SLINK"
    continue
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
      "Answer "y" or "n" please"
    fi
  done
done
