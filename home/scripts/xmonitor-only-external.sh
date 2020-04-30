#!/bin/sh

set -e

xrandr --output LVDS-0 --off --output DP-0 --auto --primary
sleep 7
bspc monitor LVDS-0 -r
sleep 2
bspc wm -r
