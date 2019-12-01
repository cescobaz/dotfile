#!/bin/bash

REF=$(realpath $(dirname $0))

echo "[INFO] installing haskell linter: hindent"
stack install hindent

echo "[INFO] installing haskell-ide-engine"
git clone https://github.com/haskell/haskell-ide-engine --recurse-submodules
cd haskell-ide-engine
stack ./install.hs build

cd $REF
