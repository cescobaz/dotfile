#!/bin/bash

REF=$(realpath $(dirname $0))

source "$REF/lib.sh"

brew list ktlint || brew install ktlint
brew list kotlin || brew install kotlin

DEST_DIRECTORY="$HOME/.kotlin-language-server"
clone_or_pull https://github.com/fwcd/kotlin-language-server.git "$DEST_DIRECTORY"
cd "$DEST_DIRECTORY"
./gradlew :server:installDist

cd "$REF"
