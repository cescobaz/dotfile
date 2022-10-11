#!/bin/sh

set -e

PREVIOUS_IP='127.0.0.1'
DIGITALOCEAN_TOKEN=$1

while [ 0 ]; do
  IP=$(curl "https://cescobaz.com/myip.php")

  if [ "$PREVIOUS_IP" != "$IP" ]; then
    echo "IP is changed: $IP"
    curl --fail -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" \
      -H "Content-Type: application/json" \
      -d "{ \"type\": \"A\", \"data\": \"$IP\" }" \
      -X PATCH \
      "https://api.digitalocean.com/v2/domains/burelli.xyz/records/160453700" > /dev/null
    curl --fail -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" \
      -H "Content-Type: application/json" \
      -d "{ \"type\": \"A\", \"data\": \"$IP\" }" \
      -X PATCH \
      "https://api.digitalocean.com/v2/domains/burelli.xyz/records/341921471" > /dev/null
    PREVIOUS_IP=$IP
  fi

  sleep 600
done
