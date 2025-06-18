#!/bin/sh

set -ex

if type "podman" >/dev/null; then
  container_runner=podman
else
  container_runner=docker
fi

$container_runner run -d \
  --network dev \
  -v $HOME/.postgres-data-$container_runner:/var/lib/postgresql/data \
  -p 5432:5432 \
  --name postgresql \
  --env POSTGRES_PASSWORD=postgres \
  docker.io/postgres:16
