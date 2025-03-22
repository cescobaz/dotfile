#!/bin/sh

WAYLAND_DISPLAY=wayland-1

ps aux \
  | grep swaylock \
  | grep -v swayidle \
  | grep -v grep \
  | awk '{ print $2 }' \
  | xargs kill -s SIGUSR1
