#!/bin/bash

set -e

DIR=$(dirname $(realpath $0))
sleep 1
$DIR/sway-lock.sh
sleep 2
systemctl suspend
