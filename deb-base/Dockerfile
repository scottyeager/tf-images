ARG PARENT=ubuntu:latest
FROM $PARENT
LABEL org.opencontainers.image.source=https://github.com/scottyeager/tf-images

# A slim layer on the base image, which provides sshd and a variety of missing
# system utilities via busybox. Adding openssl and ca-certificates allows
# busybox wget to do proper https with verifcation of certs
RUN apt update && apt install -y --no-install-recommends \
                                 openssh-server \
                                 busybox \
                                 openssl \
                                 ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Remove auto generated host keys
RUN rm /etc/ssh/ssh_host_*

# Create symlinks to busybox for any missing commands. Packaged versions from
# apt installed later will overwrite the symlinks, thus taking preference
RUN busybox --install -s /usr/bin

# Install zinit, our pid 1
ARG ZINIT_VERSION=0.2.14
RUN wget https://github.com/threefoldtech/zinit/releases/download/v$ZINIT_VERSION/zinit -O /sbin/zinit && \
  chmod +x /sbin/zinit

# Copy in the zinit unit files and scripts, to setup and start sshd
COPY zinit /etc/zinit
COPY ssh-init.sh / 

ENTRYPOINT  ["zinit", "init"]
