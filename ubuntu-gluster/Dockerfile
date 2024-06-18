FROM ghcr.io/scottyeager/ubuntu:24.04

RUN apt update && apt install -y --no-install-recommends \
    glusterfs-server \
    glusterfs-client \
    && rm -rf /var/lib/apt/lists/*

COPY zinit /etc/zinit
COPY gluster-init.sh /
RUN chmod +x /gluster-init.sh
