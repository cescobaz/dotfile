#!/bin/sh

CARD_PATH=/sys/class/drm/card1/device

# https://unix.stackexchange.com/questions/620072/reduce-amd-gpu-wattage
echo "profile_min_sclk" |\
  sudo tee "$CARD_PATH/power_dpm_force_performance_level"
