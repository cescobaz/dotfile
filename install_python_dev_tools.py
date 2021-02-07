#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

pip install yapf
pip3 install yapf

pip install python-language-server
pip3 install python-language-server

create_home_link ".vim/ftplugin/python.vim"
