#!/bin/bash

set -e

sleep 1
$HOME/scripts/sway/sway-lock.sh
sleep 2
systemctl suspend
