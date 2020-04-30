#!/bin/sh

set -e

xrandr --output DP-0 --off --output LVDS-0 --auto --primary
bspc monitor DP-0 -r
bspc wm -r
