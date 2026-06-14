#!/bin/sh

set -ex

#OUTPUT=HDMI-A-1
OUTPUT=HDMI-A-2

swaymsg output $OUTPUT scale 2 mode 3840x2160@120.000Hz max_render_time off allow_tearing yes adaptive_sync off
