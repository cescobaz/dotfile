#!/bin/sh

# auto, high, low
PROFILE=${1:-auto}

echo $PROFILE | sudo tee /sys/class/drm/card0/device/power_dpm_force_performance_level
