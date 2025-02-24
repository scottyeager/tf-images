#!/bin/bash

REPO_NAME=$(basename "$GIT_REPO" .git)
sudo -u www-data PASSWORD="$PASSWORD" code-server \
    --disable-workspace-trust \
    --bind-addr 0.0.0.0:8080 \
    /var/www/git/"$REPO_NAME"
