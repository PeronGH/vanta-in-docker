#!/bin/sh
set -eu

find /opt/vanta -mindepth 1 -maxdepth 1 ! -name vanta.conf.default -exec cp -a {} /var/vanta/ \;

if [ ! -e /var/vanta/vanta.conf ]; then
  if [ -z "${VANTA_TOKEN:-}" ]; then
    echo "Not enrolled yet: set VANTA_TOKEN to the enrollment token from Vanta." >&2
    exit 1
  fi
  install -m 600 /opt/vanta/vanta.conf.default /var/vanta/vanta.conf
  if ! vanta-cli config update --base64="$VANTA_TOKEN"; then
    rm -f /var/vanta/vanta.conf
    exit 1
  fi
  echo "Enrollment config written."
fi

exec /var/vanta/metalauncher
