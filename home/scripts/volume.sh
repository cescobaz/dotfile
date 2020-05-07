#!/bin/sh

ACTION=$1
VALUE=$2

INDEX=$(pactl list sinks short | awk '{print $1}')

get_volume() {
  VOLUMES=$(pactl list sinks | grep 'Volume' | grep -iv 'base volume' | sed 's/.* \([0-9]\+\)%.* \([0-9]\+\)%.*/\1 \2/g')
  LEFT=$(echo "$VOLUMES" | awk '{print $1}')
  RIGHT=$(echo "$VOLUMES" | awk '{print $2}')
  echo $((($LEFT + $RIGHT) / 2))
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

if [ "$ACTION" == "set" ]; then
  pactl set-sink-mute "$INDEX" 0
  pactl set-sink-volume "$INDEX" "$VALUE"
elif [ "$ACTION" == "toggle-mute" ]; then
  pactl set-sink-mute "$INDEX" toggle
elif [ "$ACTION" == "get-volume" ]; then
  get_volume
elif [ "$ACTION" == "subscribe-volume" ]; then
  pactl subscribe | subscribe_volume
fi
