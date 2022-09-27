#!/bin/sh

set -e

SRC=$(realpath $(dirname $(realpath $0)))
SERVICE_NAME='dynamic-dns'
EXEC="${SRC}/${SERVICE_NAME}.sh ${DIGITALOCEAN_TOKEN}"

DEST_SERVICE_FILE=/etc/systemd/system/$SERVICE_NAME.service
sudo test -f "{DEST_SERVICE_FILE}" && sudo rm "${DEST_SERVICE_FILE}"
cat "${SRC}/${SERVICE_NAME}.service" | sed s\\execstart_placeholder\\"${EXEC}"\\ | sudo tee "${DEST_SERVICE_FILE}" > /dev/null
