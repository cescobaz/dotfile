#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

clone_or_pull https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
clone_or_pull https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
