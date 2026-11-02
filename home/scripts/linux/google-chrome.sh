#!/bin/sh
# Launch the sandboxed Flatpak Chrome (see ansible install-chrome-flatpak.yml).
# Linked as ~/.local/bin/buro-google-chrome.sh, so bemenu-run lists it.
exec flatpak run com.google.Chrome "$@"
