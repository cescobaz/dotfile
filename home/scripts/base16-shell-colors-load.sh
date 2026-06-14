#!/usr/bin/env bash
# base16-shell-colors-load.sh — load the current base16 theme as $base00..$base0F hex vars.
#
# Source this from another script (Linux or macOS):
#     source "$HOME/scripts/base16-shell-colors-load.sh"
#     echo "$base0A"   # -> #e0ac16
#
# Colors come from base16-shell, which keeps the current theme at the
# ~/.base16_theme symlink (env-independent, set on every theme switch) and
# also exports $BASE16_THEME in interactive shells. We prefer the symlink and
# fall back to $BASE16_THEME so this works regardless of how the process was
# launched (sway exec, login shell, cron, etc.).
#
# The theme files define ANSI-ordered colorNN="rr/gg/bb" values; we remap them
# back to base16 slots and convert to "#rrggbb".
#
# Note: we do NOT source the theme file — it emits terminal escape sequences and
# unsets all colorNN at the end. Instead we extract just the assignment block
# (color00=…  up to the first blank line) and eval it, the same trick used by
# base16-shell's own `colortest`.

base16_load() {
  local theme_file=""
  if [ -f "$HOME/.base16_theme" ]; then
    theme_file="$HOME/.base16_theme"
  elif [ -n "${BASE16_THEME:-}" ]; then
    theme_file="$HOME/.config/base16-shell/scripts/base16-${BASE16_THEME}.sh"
  fi

  if [ -z "$theme_file" ] || [ ! -f "$theme_file" ]; then
    echo "base16-colors: no theme found (~/.base16_theme or \$BASE16_THEME)" >&2
    return 1
  fi

  # Define colorNN="rr/gg/bb" in the current scope (comments stripped).
  local color00 color01 color02 color03 color04 color05 color06 color07 \
        color08 color15 color16 color17 color18 color19 color20 color21
  eval "$(awk '/^color00=/,/^$/' "$theme_file" | sed 's/#.*//')"

  # base16 slot -> base16-shell colorNN (per the theme files' own comments).
  base00="#${color00//\//}"; base01="#${color18//\//}"
  base02="#${color19//\//}"; base03="#${color08//\//}"
  base04="#${color20//\//}"; base05="#${color07//\//}"
  base06="#${color21//\//}"; base07="#${color15//\//}"
  base08="#${color01//\//}"; base09="#${color16//\//}"
  base0A="#${color03//\//}"; base0B="#${color02//\//}"
  base0C="#${color06//\//}"; base0D="#${color04//\//}"
  base0E="#${color05//\//}"; base0F="#${color17//\//}"
}

base16_load
