#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

npm install -g @vue/cli

cd "$REF"
