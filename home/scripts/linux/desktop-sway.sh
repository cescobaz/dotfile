#!/bin/sh

set -ex

swaymsg output HDMI-A-1 scale 2 mode 3840x2160@59.997Hz max_render_time off adaptive_sync off allow_tearing no
