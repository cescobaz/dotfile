#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
