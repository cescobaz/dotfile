#!/bin/sh

INTERFACE=$(ip link | awk '{ print $2 }' | grep -E '^wl' | sed s/:// | head -n 1)

sudo resolvectl dns $INTERFACE 1.1.1.1
