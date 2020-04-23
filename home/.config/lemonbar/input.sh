#!/bin/bash

clock() {
  DATETIME=$(date)
  echo -n "$DATETIME"
}

while true; do
  echo "%{c}%{F#EEEEEE} $(clock)"
  sleep 1
done
