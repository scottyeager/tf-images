FROM ghcr.io/scottyeager/ubuntu:22.04

RUN apt update && \
  apt -y install sudo ufw inotify-tools

RUN wget -O /sbin/caddy 'https://caddyserver.com/api/download?os=linux&arch=amd64&p=github.com%2Fcaddyserver%2Freplace-response&idempotency=43631173212363' && \
  chmod +x /sbin/caddy

RUN wget -O /usr/local/bin/install-docker.sh https://get.docker.com && \
  chmod +x /usr/local/bin/install-docker.sh

RUN sh /usr/local/bin/install-docker.sh

COPY ./Caddyfile /etc/caddy/
COPY ./scripts/ /scripts/
COPY ./zinit/ /etc/zinit/
RUN chmod +x /scripts/*.sh

ENTRYPOINT ["/sbin/zinit", "init"]
