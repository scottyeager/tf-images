FROM ghcr.io/scottyeager/ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt -y install docker.io

RUN mkdir -p /etc/zinit
COPY zinit /etc/zinit

ENTRYPOINT [ "/sbin/zinit", "init" ]
