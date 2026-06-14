#!/usr/bin/env bash
# Themed bemenu wrapper, colored from the current base16 theme.
# Works on Wayland (sway) and X11. Self-contained — resolves its own colors via
# base16-shell-colors-load.sh, so callers stay in sync with the active theme.
#
# Modes (first arg, default "run"):
#   run    -> bemenu-run : application launcher, executes the chosen command
#   dmenu  -> bemenu     : reads candidates on stdin, prints the choice (dmenu)
#
# Env knobs:
#   MENU_PROMPT  prompt text shown left of the input (default: empty/hidden)
#   MENU_FONT    font string (default: LektonNerdFontMono 12)
#
# Examples:
#   set $menu ~/scripts/linux/menu.sh                      # sway launcher
#   chooser_cmd=MENU_PROMPT=screencast ~/scripts/linux/menu.sh dmenu
set -euo pipefail

case "${1:-run}" in
  run)   bin=bemenu-run ;;
  dmenu) bin=bemenu ;;
  *) echo "usage: ${0##*/} [run|dmenu]" >&2; exit 2 ;;
esac

# Only relevant when launching apps (run mode); harmless but pointless for dmenu.
if [ "$bin" = bemenu-run ]; then
  export GTK_THEME=Qogir-Round-Dark
  if [ -n "${WAYLAND_DISPLAY:-}" ]; then
    export QT_QPA_PLATFORM=wayland MOZ_ENABLE_WAYLAND=1
  fi
fi

source "$HOME/scripts/base16-shell-colors-load.sh"

exec "$bin" \
  --prompt "${MENU_PROMPT:-}" --no-spacing \
  --ignorecase --list 10 --counter always \
  --fn "${MENU_FONT:-LektonNerdFontMono 12}" \
  --center --fixed-height \
  --border 2 --margin 22 --line-height 34 --ch 18 --cw 9 --width-factor 0.6 \
  --nb "$base00" \
  --ab "$base00" \
  --fb "$base00" \
  --bdr "$base0A" \
  --tf "$base0A" \
  --hb "$base0A" --hf "$base00"
