#!/bin/sh

ACTION=$1
VALUE=$2

INDEX=$(pactl list sinks short | awk '{print $1}')

get_volume() {
  pactl list sinks | grep 'Volume' | grep -iv 'base volume' | sed 's/.* \([0-9]\+\)%.* \([0-9]\+\)%.*/\1 \2/g'
}

if [ "$ACTION" == "set" ]; then
  pactl set-sink-mute "$INDEX" 0
  pactl set-sink-volume "$INDEX" "$VALUE"
elif [ "$ACTION" == "toggle-mute" ]; then
  pactl set-sink-mute "$INDEX" toggle
elif [ "$ACTION" == "get-volume" ]; then
  get_volume
fi
