#!/bin/bash

xdotool search --any '' | xargs -L 1 xprop -id

# bspc query --tree -m | jq | grep -i class
