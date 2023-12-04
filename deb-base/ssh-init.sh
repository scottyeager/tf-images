#!/bin/bash

# Generate host keys if needed
ssh-keygen -A

if ! [ -f /root/.ssh/authorized_keys ]; then
  mkdir -p /root/.ssh
  echo $SSH_KEY > /root/.ssh/authorized_keys
fi
