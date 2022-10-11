#!/bin/sh

set -e

DIGITALOCEAN_TOKEN=$1

curl --fail -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" \
  -H "Content-Type: application/json" \
  "https://api.digitalocean.com/v2/domains/burelli.xyz/records"
