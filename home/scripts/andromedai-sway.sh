#!/bin/sh

set -ex

swaymsg "workspace 1; exec ~/scripts/kitty-andromedai.sh"
# swaymsg "workspace 8; exec firefox --profile ~/.mozilla/firefox/TIdSrxLp.Profile\ 1"
swaymsg "workspace 8; exec ~/scripts/linux/google-chrome.sh"
swaymsg "workspace 10; exec ~/scripts/linux/slack-wayland.sh"

# Flatpak Chrome maps late and sway's exec workspace tracking misses it, so
# it lands on the focused workspace. Wait for its window and move it to 8.
for _ in $(seq 60); do
    if swaymsg -t get_tree | grep -q '"app_id": "google-chrome"'; then
        swaymsg '[app_id="google-chrome"] move container to workspace 8'
        break
    fi
    sleep 0.5
done
