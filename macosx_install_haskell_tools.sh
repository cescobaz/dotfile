#!/bin/bash

REF=$(realpath $(dirname $0))

echo "[INFO] installing haskell linter: hindent"
stack install hindent

echo "[INFO] installing haskell-ide-engine"
HASKELL_IDE_ENGINE_DIR="$HOME/.haskell-ide-engine"
git clone https://github.com/haskell/haskell-ide-engine --recurse-submodules "$HASKELL_IDE_ENGINE_DIR"
cd "$HASKELL_IDE_ENGINE_DIR"
stack ./install.hs build
echo "[INFO] haskell-ide-engine installed into $HASKELL_IDE_ENGINE_DIR, do not remove folder"

cd $REF