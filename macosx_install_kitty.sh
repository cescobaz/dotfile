#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

clone_or_pull https://github.com/kovidgoyal/kitty

cd ./kitty
make
make app
rm -rf /Applications/kitty.app
cp -r ./kitty.app /Applications/

sudo tic -xe xterm-kitty ./terminfo/kitty.terminfo

cd "$REF"
rm -rf ./kitty

create_home_link '.config/kitty'
