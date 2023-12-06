FROM ghcr.io/scottyeager/ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt -y install docker.io

RUN mkdir -p /etc/zinit
COPY ps /etc/zinit

ENTRYPOINT [ "/sbin/zinit", "init" ]
