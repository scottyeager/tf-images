#!/bin/bash

redis-server --daemonize yes

# Set up SSH
cp -r /root/ssh/* /root/.ssh/
chmod 600 /root/.ssh/*
eval $(ssh-agent)
ssh-add /root/.ssh/*

# Support optionally bind mounting our local herolib into the container
# If not present, use the cloned version. We don't mess with git on the user's
# system (it will fail for ownership reasons anyway)
rm -f /root/.vmodules/freeflowuniverse/herolib
if [ -d "/opt/herolib_mount" ]; then
    ln -s /opt/herolib_mount/lib /root/.vmodules/freeflowuniverse/herolib
    cd /opt/herolib_mount
else
    ln -s /opt/herolib/lib /root/.vmodules/freeflowuniverse/herolib
    cd /opt/herolib
    git fetch
    git checkout "${HEROLIB_REF:-development}"
    git pull
fi

cd cli
echo "Building hero..."
# Only print the logs if building fails
v -enable-globals hero.v > build.log 2>&1 || (cat build.log && exit 1)
ln -s $(realpath hero) /bin/hero

cd /root

# This way we can pass commands to the container, such as "sleep infinity", or
# pass no commands and run in interactive mode to get a shell
if [ $# -gt 0 ]; then
    exec bash -c "$@"
else
    exec bash
fi
