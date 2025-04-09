#!/bin/sh

set -ex

if type "podman" >/dev/null; then
  container_runner=podman
else
  container_runner=docker
fi

$container_runner start postgresql

kitty --session andromedai
