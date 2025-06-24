#!/bin/sh

set -ex

if type "podman" >/dev/null; then
  container_runner=podman
else
  container_runner=docker
fi

# to upgrade postgres version, backup data, upgrade, then restore backup
# docker exec -it postgresql pg_dumpall -U postgres > postgres.backup
# docker stop postgresql && docker rm postgresql
# docker cp postgres.backup postgresql:/postgres.backup                                                                        
# docker exec -it postgresql psql -U postgres -f /postgres.backup

$container_runner run -d \
  --network dev \
  -v $HOME/.postgres-data-$container_runner:/var/lib/postgresql/data \
  -p 5432:5432 \
  --name postgresql \
  --env POSTGRES_PASSWORD=postgres \
  docker.io/postgres:16
