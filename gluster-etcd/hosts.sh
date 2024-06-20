#!/bin/bash
if ! grep -Pzq "${HOSTS//$'\n'/'\n'}" /etc/hosts; then
  echo "$HOSTS" >> /etc/hosts
fi
