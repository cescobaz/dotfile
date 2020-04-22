#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 ACTION ARGS"
  exit 1
fi

DIR=$(pwd)

while true; do
  cabal "$@" &
  PID=$!
  echo "PROCESS: $PID"

  fswatch --one-event --latency 2 \
    --exclude '.*' \
    --include '/src/.*\.hs$' \
    --include '/test/.*\.hs$' \
    --include '/src/.*\.hsc$' \
    --include '.*\.cabal$' \
    --exclude '.*dist-newstyle.*' "$DIR"
  echo "CHANGE DETECTED ----------------------------------------------------"
  echo "killing $PID"
  kill $PID
  while kill -0 $PID; do
    sleep 1
  done

  sleep 1
  EXITCODE=$?
  if [ $EXITCODE -ne 0 ]; then
    exit $EXITCODE
  fi
done
