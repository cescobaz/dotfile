#!/bin/sh

docker stop linux-vm && docker rm linux-vm

docker run -d \
  --name linux-vm \
  --hostname linux-vm \
  -v /:/macos \
  -it linux-vm
