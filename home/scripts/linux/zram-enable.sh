#!/bin/sh

set -ex

modprobe zram
sleep 2
zramctl /dev/zram0 --algorithm zstd --size 16G
mkswap --label zram0 /dev/zram0
swapon --priority 100 /dev/zram0
