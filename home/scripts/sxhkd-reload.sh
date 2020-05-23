#!/bin/bash

pkill -USR1 -x sxhkd
sleep 1

setxkbmap us -option
setxkbmap us -option "ctrl:swapcaps,altwin:swap_lalt_lwin"
