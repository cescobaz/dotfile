#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 ACTION ARGS"
  exit 1
fi

DIR=$(pwd)

wait_changes_macosx() {
  fswatch --one-event --latency 2 \
    --exclude '.*' \
    --include '/src/.*\.hs$' \
    --include '/test/.*\.hs$' \
    --include '/src/.*\.hsc$' \
    --include '.*\.cabal$' \
    --exclude '.*dist-newstyle.*' "$DIR"
}

wait_changes_linux() {
  inotifywait -r -e close_write \
    --include '(src/.*\.hs$)|(test/.*\.hs$)|(.*\.cabal$)' \
    "$DIR"
}

wait_changes() {
  type inotifywait
  if [ "$?" == "0" ]; then
    echo "wait_changes_linux ..."
    wait_changes_linux
  else
    wait_changes_macosx
  fi
}

while true; do
  cabal "$@" &
  PID=$!
  echo "PROCESS: $PID"

  wait_changes
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
