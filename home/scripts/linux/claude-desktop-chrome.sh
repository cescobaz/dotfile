#!/bin/sh
# Launch Claude Desktop with links opened in the Flatpak Chrome.
# Electron opens links via xdg-open/BROWSER: route them to Chrome, like slack.
# Linked as ~/.local/bin/buro-claude-desktop-chrome.sh, so bemenu-run lists it.
scripts_dir=$(dirname "$(readlink -f "$0")")/..
export BROWSER="$scripts_dir/linux/google-chrome.sh"
export PATH="$scripts_dir/andromedai-bin:$PATH"
exec /usr/bin/claude-desktop "$@"
