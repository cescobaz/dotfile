#!/bin/bash

set -e

REF=$(realpath $(dirname $0))
source "$REF/lib.sh"

install_aur b43-firmware
install_via_pkg_mng wpa_supplicant
