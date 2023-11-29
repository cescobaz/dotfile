#!/bin/bash

set -e

sleep 1
swaylock --daemonize -f -c 333333
sleep 2
systemctl suspend
