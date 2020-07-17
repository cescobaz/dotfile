#!/bin/sh

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

pacman -S rxvt-unicode zsh openssh tmux fd ripgrep fzf

pacman -S lm_sensors

pacman -S python-pip

pacman -S xclip

pacman -S firefox keepassxc
