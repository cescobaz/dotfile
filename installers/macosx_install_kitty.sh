#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

brew install kitty

create_home_link '.config/kitty'
