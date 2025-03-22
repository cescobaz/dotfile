#!/bin/sh

set -e

rmmod rt2800usb && modprobe rt2800usb

systemctl restart wpa_supplicant@wlp1s0f0u8.service
