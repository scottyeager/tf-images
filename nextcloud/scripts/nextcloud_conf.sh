#!/bin/bash

# Wait for the nextcloud container to become healthy. Note that we can set the
# richtext config parameters even before the app is installed

nc_ready () {
  until [[ "`docker inspect -f {{.State.Health.Status}} nextcloud-aio-nextcloud 2> /dev/null`" == "healthy" ]]; do
      sleep 1;
  done;
}

# When a gateway is used, AIO sets the WOPI allow list to only include the
# gateway IP. Since requests don't originate from the gateway IP, they are 
# blocked by default. Here we add the public IP of the VM, or of the router 
# upstream of the node
# See: github.com/nextcloud/security-advisories/security/advisories/GHSA-24x8-h6m2-9jf2

if $IPV4; then
  interface=$(ip route show default | cut -d " " -f 5)
  ipv4_address=$(ip a show $interface | grep -Po 'inet \K[\d.]+')
fi

if $GATEWAY; then
  nc_ready
  wopi_list=$(docker exec --user www-data nextcloud-aio-nextcloud php occ config:app:get richdocuments wopi_allowlist)

  if $IPV4; then
    ip=$ipv4_address
  else
    ip=$(curl -fs https://ipinfo.io/ip)
  fi

  if [[ $ip ]] && ! echo $wopi_list | grep -q $ip; then
    docker exec --user www-data nextcloud-aio-nextcloud php occ config:app:set richdocuments wopi_allowlist --value=$ip
  fi
fi


# If the VM has a gateway and a public IPv4, then AIO will set the STUN/TURN 
# servers to the gateway domain which does not point to the public IP, so we  
# use the IP instead. In this case, we must wait for the Talk app to be
# installed before changing the settings. With inotifywait, we don't need
# a busy loop that could run indefinitely

apps_dir=/mnt/data/docker/volumes/nextcloud_aio_nextcloud/_data/custom_apps/

if $GATEWAY && $IPV4; then
  if [[ ! -d ${apps_dir}spreed ]]; then
    inotifywait -qq -e create --include spreed $apps_dir
  fi
  nc_ready
  
  turn_list=$(docker exec --user www-data nextcloud-aio-nextcloud php occ talk:turn:list)
  turn_secret=$(echo "$turn_list" | grep secret | cut -d " " -f 4)
  turn_server=$(echo "$turn_list" | grep server | cut -d " " -f 4)
  
  if ! echo $turn_server | grep -q $ipv4_address; then
    docker exec --user www-data nextcloud-aio-nextcloud php occ talk:turn:delete turn $turn_server udp,tcp
    docker exec --user www-data nextcloud-aio-nextcloud php occ talk:turn:add turn $ipv4_address:3478 udp,tcp --secret=$turn_secret
  fi
  
  stun_list=$(docker exec --user www-data nextcloud-aio-nextcloud php occ talk:stun:list)
  stun_server=$(echo $stun_list | cut -d " " -f 2)
  
  if ! echo $stun_server | grep -q $ipv4_address; then
    docker exec --user www-data nextcloud-aio-nextcloud php occ talk:stun:add $ipv4_address:3478
    docker exec --user www-data nextcloud-aio-nextcloud php occ talk:stun:delete $stun_server
  fi
fi
