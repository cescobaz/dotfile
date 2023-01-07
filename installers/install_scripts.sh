#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

LINKS=(
  "scripts"
)

create_home_links "$LINKS"
