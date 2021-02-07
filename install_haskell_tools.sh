#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

while true; do
  echo "[INFO] ghcup installation: at the end of ghcup installation the PATH will update on .custom_env file, answer NO to ghcup prompt for env var"
  echo "[Q] do you want to install ghcup? (y/n)"
  read ANSWER
  if [ "$ANSWER" == "n" ]; then break; fi
  if [ "$ANSWER" == "y" ]; then
    echo "[INFO] installing ghcup"
    sudo curl https://get-ghcup.haskell.org -sSf | sh
    echo "[INFO] ghcup installed, installing env to .custom_env"
    echo '[ -f "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env" ] && source "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env"' >> "$HOME/.custom_env"
    exit 0
  fi
done

ghcup install 8.6.5
ghcup set 8.6.5

echo "[INFO] installing haskell fixer: brittany"
cabal install floskell
create_home_link '.config/.floskell.json'

echo "[INFO] installing haskell-language-server"
ghcup install hls

cd $REF
