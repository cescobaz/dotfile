#!/bin/sh

set -ex

# Resolve the repo scripts dir through the ~/.local/bin/buro-* symlink.
scripts_dir=$(dirname "$(readlink -f "$0")")

swaymsg "workspace 1; exec '$scripts_dir/kitty-andromedai.sh'"
# swaymsg "workspace 8; exec firefox --profile ~/.mozilla/firefox/TIdSrxLp.Profile\ 1"
swaymsg "workspace 8; exec '$scripts_dir/linux/google-chrome.sh'"
# Slack opens links via xdg-open/BROWSER: route them to Chrome, like kitty.
swaymsg "workspace 10; exec env BROWSER='$scripts_dir/linux/google-chrome.sh' PATH='$scripts_dir/andromedai-bin:$PATH' '$scripts_dir/linux/slack-wayland.sh'"

# Flatpak Chrome maps late and sway's exec workspace tracking misses it, so
# it lands on the focused workspace. Wait for its window and move it to 8.
for _ in $(seq 60); do
    if swaymsg -t get_tree | grep -q '"app_id": "google-chrome"'; then
        swaymsg '[app_id="google-chrome"] move container to workspace 8'
        break
    fi
    sleep 0.5
done
