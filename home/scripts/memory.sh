#!/bin/bash

memory() {
  free | grep Mem | awk '{ printf("%.0f%%", $3/$2 * 100.0) }'
}

if [ "$1" == 'subscribe' ]; then
  while true; do
    echo $(memory)
    sleep 1
  done
else
  memory
fi
