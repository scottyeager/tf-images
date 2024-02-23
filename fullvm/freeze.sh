#/bin/bash

container=$1

tmp=$(mktemp -d)
pushd $tmp

# Tag the image with it's own hash, just as a unique temp id
# Docker won't accept has below in --from
image=$(docker commit $container | cut -d ':' -f 2 | cut -c 1-10)
docker tag $image $image

cat << END > $tmp/Dockerfile
FROM ubuntu AS touchup

RUN mkdir rootfs

COPY --from=$image / rootfs

RUN rm rootfs/etc/resolv.conf
RUN ln -s /run/systemd/resolve/resolv.conf rootfs/etc/resolv.conf
RUN cat <<EOF > rootfs/etc/hosts
127.0.0.1 localhost

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

RUN tar cf img.tar -C rootfs .

FROM scratch AS archive

COPY --from=touchup /img.tar /
END

docker buildx build --output=. .
popd
cp ${tmp}/img.tar ./
rm -r $tmp
docker image rm $image
