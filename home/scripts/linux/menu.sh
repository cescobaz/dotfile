#!/usr/bin/env bash
# Application launcher: bemenu-run themed from the current base16 theme.
# Works on Wayland (sway) and X11. Self-contained — resolves its own colors via
# base16-shell-colors-load.sh, so the WM only needs:
#     set $menu ~/scripts/linux/menu.sh        # sway
# Launched apps are forced onto Wayland only when we're actually in a Wayland
# session; under X11 they keep their default backend.
set -euo pipefail

source "$HOME/scripts/base16-shell-colors-load.sh"

export GTK_THEME=Qogir-Round-Dark
if [ -n "${WAYLAND_DISPLAY:-}" ]; then
  export QT_QPA_PLATFORM=wayland MOZ_ENABLE_WAYLAND=1
fi

exec bemenu-run \
  --prompt '' --no-spacing \
  --ignorecase --list 10 --counter always \
  --fn "${MENU_FONT:-LektonNerdFontMono 12}" \
  --center --fixed-height \
  --border 2 --margin 22 --line-height 34 --ch 18 --cw 9 --width-factor 0.6 \
  --bdr "$base0A" \
  --tf "$base0A" \
  --hb "$base0A" --hf "$base00"
