#!/bin/sh

echo "Usage: $0 [MODE]\
  MODE (default=1) could be 1 (PageCache), 2 (dentries and inodes), 3 (PageCache, dentries and inodes)"

MODE=${1:-1}
sync
echo $MODE | sudo tee /proc/sys/vm/drop_caches
