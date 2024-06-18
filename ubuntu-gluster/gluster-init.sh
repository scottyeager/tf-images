#!/bin/bash

mkdir -p /data/gv0
mkdir /mnt/gluster

if $LEADER; then
  sleep $TIMEOUT1
  gluster peer probe $PEER1
  gluster peer probe $PEER2
  gluster volume create gv0 replica 3 ${ME}:/data/gv0 ${PEER1}:/data/gv0 ${PEER2}:/data/gv0 force
  gluster volume start gv0
else
  sleep $TIMEOUT2
fi

mount -t glusterfs ${ME}:/gv0 /mnt/gluster
