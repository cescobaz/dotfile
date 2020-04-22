#!/bin/sh

set -e

xrandr --output LVDS-0 --off --output DP-0 --auto --primary
bspc monitor LVDS-0 -r
bspc wm -r
