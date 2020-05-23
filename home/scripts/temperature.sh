#!/bin/bash

max_temperature() {
  TEMPERATURES=$(sensors | grep -E '[0-9]+.*C' | sed 's/.*+\([0-9]\+\.[0-9]\+\)°C .*/\1/')

  MAXTEMP=0
  for TEMP in $TEMPERATURES; do
    if [ $(echo "$TEMP>$MAXTEMP" | bc) == "1" ]; then
      MAXTEMP=$TEMP
    fi
  done

  echo "$MAXTEMP°C"
}

if [ "$1" == 'subscribe' ]; then
  while true; do
    echo $(max_temperature)
    sleep 3
  done
else
  max_temperature
fi
