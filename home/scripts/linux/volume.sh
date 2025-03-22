#!/bin/sh

ACTION=$1
VALUE=$2

INDEX=$(pactl list sinks short | grep -i analog | awk '{print $1}')
INDEX='@DEFAULT_SINK@'

get_volume() {
  VOLUMES=$(pactl get-sink-volume $INDEX | head -n 1 | sed 's/.* \([0-9]\+\)%.* \([0-9]\+\)%.*/\1 \2/g')
  LEFT=$(echo "$VOLUMES" | awk '{print $1}')
  RIGHT=$(echo "$VOLUMES" | awk '{print $2}')
  echo "$((($LEFT + $RIGHT) / 2))%"
}

get_mute() {
  pactl get-sink-mute $INDEX | sed 's/.* \(\w\+\)$/\1/'
}

get_status() {
  MUTE=$(get_mute)
  if [ "$MUTE" == "yes" ]; then
    echo 'M'
  else
    get_volume
  fi
}

subscribe_volume() {
  while read -r line; do
    case $line in
    *change*sink*)
      INDEX=$(echo "$line" | sed 's/.*#\([0-9]\+\)$/\1/')
      get_volume
      ;;
    esac
  done
}

subscribe_status() {
  while read -r line; do
    case $line in
    *change*sink*)
      get_status
      ;;
    esac
  done
}

if [ "$ACTION" == "set" ]; then
  pactl set-sink-mute "$INDEX" 0
  pactl set-sink-volume "$INDEX" "$VALUE"
elif [ "$ACTION" == "toggle-mute" ]; then
  pactl set-sink-mute "$INDEX" toggle
elif [ "$ACTION" == "get-volume" ]; then
  get_volume
elif [ "$ACTION" == "subscribe-volume" ]; then
  get_volume
  pactl subscribe | subscribe_volume
elif [ "$ACTION" == "subscribe-status" ]; then
  get_status
  pactl subscribe | subscribe_status
fi
