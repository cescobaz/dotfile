#!/bin/bash

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

echo "[INFO] installing ghcup"
sudo curl https://get-ghcup.haskell.org -sSf | sh
ghcup install 8.6.5
ghcup set 8.6.5

echo "[INFO] installing haskell fixer: brittany"
cabal v2-install floskell

echo "[INFO] installing haskell-ide-engine"
HASKELL_IDE_ENGINE_DIR="$HOME/.haskell-ide-engine"
git clone https://github.com/haskell/haskell-ide-engine --recurse-submodules
cd haskell-ide-engine
cabal v2-run ./install.hs --project-file install/shake.project hie-8.6.5
cd ..
mv haskell-ide-engine "$HASKELL_IDE_ENGINE_DIR"
echo "[INFO] haskell-ide-engine installed into $HASKELL_IDE_ENGINE_DIR, do not remove folder"
ls "$HASKELL_IDE_ENGINE_DIR"

cd $REF
