#!/bin/bash

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

echo "[INFO] installing ghcup"
sudo curl https://get-ghcup.haskell.org -sSf | sh
ghcup install 8.6.5
ghcup set 8.6.5
# maybe the following line shoul be installed to shell
# source $HOME/.ghcup/env
# echo 'source $HOME/.ghcup/env' >> "$HOME/.custom_env"

echo "[INFO] installing haskell fixer: brittany"
cabal install floskell

echo "[INFO] installing haskell-ide-engine"
HASKELL_IDE_ENGINE_DIR="$HOME/.haskell-ide-engine"
git clone https://github.com/haskell/haskell-ide-engine --recurse-submodules
cd haskell-ide-engine
cabal run ./install.hs --project-file install/shake.project hie-8.6.5
cabal run ./install.hs --project-file install/shake.project data
cd ..
mv haskell-ide-engine "$HASKELL_IDE_ENGINE_DIR"
echo "[INFO] haskell-ide-engine installed into $HASKELL_IDE_ENGINE_DIR, do not remove folder"
ls "$HASKELL_IDE_ENGINE_DIR"

cd $REF
