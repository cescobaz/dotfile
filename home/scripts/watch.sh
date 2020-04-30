#!/bin/bash
if [ $# -ne 2 ]; then
        echo  "Usage: watch.sh INTERVAL COMMAND"
        exit 1
fi

while :; 
  do 
  printf '\33c\e[3J'
  date
  echo '-------------------------'
  $2
  sleep $1
done
