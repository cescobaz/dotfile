#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

clone_or_pull https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
