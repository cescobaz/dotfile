#!/bin/bash

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

brew list shfmt || brew install shfmt
npm i -g bash-language-server

cd "$REF"
