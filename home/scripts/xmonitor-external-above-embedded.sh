#!/bin/sh

set -e

xrandr --output LVDS-0 --auto --primary --output DP-0 --auto --above LVDS-0

bspc monitor LVDS-0 --reset-desktops I II III IV V
bspc monitor DP-0 --reset-desktops VI VII VIII IX X
bspc wm --reorder-monitors LVDS-0 DP-0
bspc wm --adopt-orphans
