#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

apt install vim-nox
