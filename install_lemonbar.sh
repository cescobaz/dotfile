#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

install_aur lemonbar-git

create_home_link ".config/lemonbar"
