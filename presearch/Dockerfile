FROM ghcr.io/scottyeager/ubuntu-docker:latest

RUN mkdir -p /etc/zinit
COPY zinit /etc/zinit

ENTRYPOINT [ "/sbin/zinit", "init" ]
