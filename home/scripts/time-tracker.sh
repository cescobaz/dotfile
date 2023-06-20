#!/bin/bash

STARTED=$(date)
SECONDS=0

echo "started at: $STARTED"

while true; do
  echo "Write 'stop' or close the input"
  read -r LINE
  if [ $? -ne 0 ] || [ "$LINE" = 'stop' ]; then
    break
  fi
done

duration=$SECONDS
minutes=$(($duration / 60))
hours=$(($duration / 60 / 60))

echo "DONE: $STARTED -> $(date)"
echo "${hours}:$(($minutes % 60)) (minutes: $minutes seconds: $duration)"
