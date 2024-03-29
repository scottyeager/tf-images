#!/bin/bash

ssh_keypath=$(echo ~/.ssh/id*.pub | head -n 1)

cat << EOF > meta-data
#cloud-config
instance-id: iid-local01
EOF

cat << EOF > user-data
#cloud-config
users:
- name: root
  ssh_authorized_keys:
    - $(cat $ssh_keypath)
EOF

genisoimage -output seed.img -volid cidata -joliet -rock user-data meta-data

echo
echo Wrote image with
echo meta-data:
cat meta-data
echo
echo user-data:
cat user-data

rm user-data meta-data
