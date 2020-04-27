#!/bin/sh

pa_sink_index() {
  pactl list sinks short | awk '{print $1}'
}

ACTION=$1
VALUE=$2

if [ "$ACTION" == "set" ]; then
  pactl set-sink-volume $(pa_sink_index) "$VALUE"
elif [ "$ACTION" == "toggle-mute" ]; then
  pactl set-sink-mute $(pa_sink_index) toggle
fi
