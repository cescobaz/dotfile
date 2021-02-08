#!/bin/sh

pkill -x panel
bspc wm -r
bspc wm --adopt-orphans
