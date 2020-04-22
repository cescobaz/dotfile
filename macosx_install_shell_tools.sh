#!/bin/bash

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

install_via_pkg_mng shfmt
npm i -g bash-language-server

cd "$REF"
