#!/bin/bash

rm -rf $(brew --cache)

docker system prune --volumes
