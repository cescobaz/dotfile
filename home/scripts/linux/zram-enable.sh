#!/bin/sh

set -e

modprobe zram
zramctl /dev/zram0 --algorithm zstd --size 16G
mkswap -U clear --label zram0 /dev/zram0
swapon --priority 100 /dev/zram0
