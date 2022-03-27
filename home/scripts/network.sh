#!/bin/bash

network() {
  networkctl status | awk '$0 ~ /Address: (.*)/ {print $2}'
}

if [ "$1" == 'subscribe' ]; then
  while true; do
    echo $(network)
    sleep 10
  done
else
  network
fi
