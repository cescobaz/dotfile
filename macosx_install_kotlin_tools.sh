#!/bin/bash

REF=$(realpath $(dirname $0))

DEST_DIRECTORY="$HOME/.kotlin-language-server"
git clone https://github.com/fwcd/kotlin-language-server.git "$DEST_DIRECTORY"
cd "$DEST_DIRECTORY"
./gradlew :server:installDist

cd "$REF"