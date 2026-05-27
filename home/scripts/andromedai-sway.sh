#!/bin/sh

set -ex

swaymsg "workspace 1; exec ~/scripts/kitty-andromedai.sh"
swaymsg "workspace 8; exec firefox --profile ~/.mozilla/firefox/TIdSrxLp.Profile\ 1"
swaymsg "workspace 10; exec ~/scripts/linux/slack-wayland.sh"
