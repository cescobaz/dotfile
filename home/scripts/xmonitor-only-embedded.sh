#!/bin/sh

set -e

xrandr --output DP-0 --off --output LVDS-0 --auto --primary
bspc monitor DP-0 -r
bspc wm -r
bspc monitor LVDS-0 --reset-desktops I II III IV V VI VII VIII IX X
bspc wm --adopt-orphans
