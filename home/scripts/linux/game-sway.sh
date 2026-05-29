#!/bin/sh

set -ex

#OUTPUT=HDMI-A-1
OUTPUT=HDMI-A-2

swaymsg output $OUTPUT scale 1 mode 1920x1080@120.000Hz max_render_time off allow_tearing yes adaptive_sync off
