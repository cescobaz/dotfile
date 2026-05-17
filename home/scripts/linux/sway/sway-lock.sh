#!/bin/sh

#swaylock --daemonize -f -c 555555 -k --indicator-idle-visible -t --image ~/wallpaper/sand.png --scaling fill
swaylock --daemonize \
  --color 231e18FF \
  --ring-color 00000000 \
  --inside-color e0ac1611 \
  --layout-bg-color 231e18FF \
  --layout-text-color 48413aFF \
  --font 'LektonNerdFontMonoBold' \
  --font-size 36 \
  --show-failed-attempts \
  --show-keyboard-layout \
  --indicator-idle-visible \
  --tiling
