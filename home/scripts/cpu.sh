#!/bin/bash

cpu() {
  vmstat --one-header $1 100 | awk 'NR>2{print 100 - $(NF-2)"%"}'
}

if [ "$1" == 'subscribe' ]; then
  while true; do
    cpu 3
    sleep 3
  done
else
  cpu
fi
