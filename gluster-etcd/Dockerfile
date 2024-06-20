FROM ghcr.io/scottyeager/ubuntu:24.04
ARG ETCD_VERSION=v3.5.14

RUN apt update && apt install -y --no-install-recommends \
    glusterfs-server \
    glusterfs-client \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/etcd-io/etcd/releases/download/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz && \
    tar xf etcd-${ETCD_VERSION}-linux-amd64.tar.gz && \
    mv etcd-${ETCD_VERSION}-linux-amd64/etcd /usr/local/bin && \
    mv etcd-${ETCD_VERSION}-linux-amd64/etcdctl /usr/local/bin && \
    mv etcd-${ETCD_VERSION}-linux-amd64/etcdutl /usr/local/bin && \
    rm -r etcd-${ETCD_VERSION}-linux-amd64.tar.gz etcd-${ETCD_VERSION}-linux-amd64

COPY zinit /etc/zinit

WORKDIR /scripts
COPY gluster-init.sh ./
COPY etcd.sh ./
COPY hosts.sh ./
RUN chmod +x ./*

WORKDIR /
