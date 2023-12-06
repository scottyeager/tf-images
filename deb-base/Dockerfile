ARG PARENT=ubuntu:latest
FROM $PARENT
LABEL org.opencontainers.image.source=https://github.com/scottyeager/tf-images

RUN apt update && apt -y install --no-install-recommends openssh-server busybox \
    && rm -rf /var/lib/apt/lists/*

# Remove auto generated host keys and create privilege separation directory
RUN rm /etc/ssh/ssh_host_*
RUN mkdir /var/run/sshd

# Create symlinks to busybox for any tools that don't already exist
# Packaged versions will overwite if installed later thus always have preference
RUN busybox --install -s /usr/bin

ARG ZINIT_VERSION=0.2.14
RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v$ZINIT_VERSION/zinit && \
  chmod +x /sbin/zinit

COPY zinit /etc/zinit
COPY ssh-init.sh / 

ENTRYPOINT  ["zinit", "init"]
