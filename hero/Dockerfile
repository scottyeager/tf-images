FROM ubuntu:24.04

RUN apt update && apt install -y curl libatomic1 sudo autoconf libtool iputils-ping net-tools git rsync curl mc tmux libsqlite3-dev xz-utils git git-lfs redis-server ufw screen fswatch

RUN curl -o /usr/local/bin/hero -L https://github.com/freeflowuniverse/herolib/releases/download/v1.0.21/hero-aarch64-unknown-linux-musl
RUN chmod +x /usr/local/bin/hero

RUN curl -fsSL https://bun.sh/install | bash

RUN mkdir /root/.ssh

COPY start.sh /
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
