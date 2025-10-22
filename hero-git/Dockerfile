FROM ubuntu:24.04 AS base

# Includes a bunch of stuff hero will try to install later, so we don't have to
# do that on each new container launch
RUN apt update && apt install -y ssh wget unzip build-essential git redis-server sudo autoconf libtool iputils-ping net-tools rsync curl mc tmux libsqlite3-dev xz-utils git-lfs ufw libpq-dev

RUN wget https://github.com/vlang/v/releases/latest/download/v_linux.zip && \
    unzip v_linux.zip && \
    cd v && \
    ./v symlink

# Install bun.sh for docusaurus
RUN curl -fsSL https://bun.sh/install | bash

# Make a new stage so we can invalidate the cache by passing --no-cache-filter
FROM base AS clone

RUN git clone https://github.com/Incubaid/herolib /opt/herolib

RUN git clone https://github.com/incubaid/docusaurus_template /root/code/github/incubaid/docusaurus_template

# Warm the bun node modules cache
RUN cd /root/code/github/incubaid/docusaurus_template/template && /root/.bun/bin/bun install

RUN mkdir -p /root/.vmodules/incubaid

# Make a place for users to mount their ssh key file. We will copy to .ssh and
# change permissions in entrypoint script
RUN mkdir -p /root/ssh

COPY entrypoint.sh /bin/entrypoint.sh

RUN chmod +x /bin/entrypoint.sh

# Make a new stage so we can invalidate the cache by passing --no-cache-filter
FROM clone AS fetch

# Fetch to freshen the repos with minimal work
RUN cd /opt/herolib && git fetch
RUN cd /root/code/github/incubaid/docusaurus_template && git fetch


ENTRYPOINT ["/bin/entrypoint.sh"]
