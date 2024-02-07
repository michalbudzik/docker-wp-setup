#!/bin/bash

set -e

source "../.env"

DOMAIN=$(echo "$DOMAIN")

sudo -- sh -c -e "echo '${IP}  ${DOMAIN}' >> C:/Windows/System32/drivers/etc/hosts" 