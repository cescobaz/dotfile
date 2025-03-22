#!/bin/bash

setxkbmap "us,it" -option
sleep 1

pkill -USR1 -x sxhkd
sleep 1

DIR=$(dirname $(realpath $0))
$DIR/xset-${KEYBOARD:-tokyo}-keyboard.sh
