#!/bin/bash

cpu() {
  vmstat $1 | awk 'NR>2{print 100 - $(NF-2)"%"}'
}

if [ "$1" == 'subscribe' ]; then
  while true; do
    cpu 1
  done
else
  cpu
fi
