#!/bin/sh

# xrandr --output LVDS-0 --auto --primary --output DP-0 --off
xrandr --output LVDS-0 --auto --primary
sleep 2
xrandr --output DP-0 --off
sleep 2
pkill -x panel
bspc quit
