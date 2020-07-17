#!/bin/bash

setxkbmap "us,it" -option
sleep 1

pkill -USR1 -x sxhkd
sleep 1

setxkbmap "us,it" -option "ctrl:swapcaps,altwin:swap_lalt_lwin"
