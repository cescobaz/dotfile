#!/bin/sh

set -e

# xrandr --output LVDS-0 --auto --primary --output DP-0 --off
xrandr --output LVDS-0 --auto --primary
sleep 5
xrandr --output DP-0 --off
sleep 5
pkill -x panel
bspc quit
