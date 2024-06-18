#!/bin/bash

mkdir -p /data/gv0
mkdir /mnt/gluster

if [ $ME == gluster1 ]; then
  sleep 2
  gluster peer probe $PEER1
  gluster peer probe $PEER2
  gluster volume create gv0 replica 3 gluster1:/data/gv0 gluster2:/data/gv0 gluster3:/data/gv0 force
  gluster volume start gv0
else
  sleep 5
fi

mount -t glusterfs ${ME}:/gv0 /mnt/gluster
