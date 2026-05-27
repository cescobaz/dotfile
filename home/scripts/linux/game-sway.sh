#!/bin/sh

set -ex

swaymsg output HDMI-A-1 scale 1 mode 1920x1080@120.000Hz max_render_time off allow_tearing yes adaptive_sync off
