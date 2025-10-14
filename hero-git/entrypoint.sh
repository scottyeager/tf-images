#!/bin/bash

redis-server --daemonize yes

# Set up SSH
cp -r /root/ssh/* /root/.ssh/
chmod 600 /root/.ssh/*
eval $(ssh-agent)
ssh-add /root/.ssh/*

cd /opt/herolib
git fetch
git checkout "${HEROLIB_REF:-development}"
git pull
echo "Building hero..."
# Only print the logs if building fails
./install_herolib.vsh > /opt/build.log 2>&1 || (cat /opt/build.log && exit 1)
./cli/compile.vsh

cd /

# This way we can pass commands to the container, such as "sleep infinity", or
# pass no commands and run in interactive mode to get a shell
if [ $# -gt 0 ]; then
    exec bash -c "$@"
else
    exec bash
fi
