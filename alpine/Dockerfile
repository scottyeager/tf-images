FROM alpine:latest
RUN apk add --no-cache openssh \
    && echo 'root:*' | chpasswd -e

# Install zinit, our pid 1
ARG ZINIT_VERSION=0.2.14
RUN wget https://github.com/threefoldtech/zinit/releases/download/v$ZINIT_VERSION/zinit -O /sbin/zinit && \
  chmod +x /sbin/zinit

# Copy in the zinit unit file to setup and start sshd
COPY zinit /etc/zinit

ENTRYPOINT  ["zinit", "init"]
