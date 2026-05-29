#!/bin/sh

set -ex

#OUTPUT=HDMI-A-1
OUTPUT=HDMI-A-2

swaymsg output $OUTPUT scale 2 mode 3840x2160@59.997Hz max_render_time off adaptive_sync off allow_tearing no
