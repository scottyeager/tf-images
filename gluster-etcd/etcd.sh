#!/bin/bash
MYIP=$(hostname -I | cut -d ' ' -f 1)
sleep $TIMEOUT1
etcd --name $ME --initial-advertise-peer-urls http://${MYIP}:2380 \
  --listen-peer-urls http://${MYIP}:2380 \
  --listen-client-urls http://${MYIP}:2379,http://127.0.0.1:2379 \
  --advertise-client-urls http://${MYIP}:2379 \
  --initial-cluster-token $ETCD_CLUSTER_TOKEN
  --initial-cluster-state new
