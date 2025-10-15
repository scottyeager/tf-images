FROM ubuntu:24.04

# Includes a bunch of stuff hero will try to install later, so we don't have to
# do that on each new container launch
RUN apt update && apt install -y ssh wget unzip build-essential git redis-server sudo autoconf libtool iputils-ping net-tools rsync curl mc tmux libsqlite3-dev xz-utils git-lfs ufw libpq-dev

RUN wget https://github.com/vlang/v/releases/latest/download/v_linux.zip && \
    unzip v_linux.zip && \
    cd v && \
    ./v symlink

# Install bun.sh for docusaurus
RUN curl -fsSL https://bun.sh/install | bash

RUN git clone https://github.com/Incubaid/herolib /opt/herolib

RUN mkdir -p /root/.vmodules/incubaid

# Make a place for users to mount their ssh key file. We will copy to .ssh and
# change permissions in entrypoint script
RUN mkdir -p /root/ssh

COPY entrypoint.sh /bin/entrypoint.sh

RUN chmod +x /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]
