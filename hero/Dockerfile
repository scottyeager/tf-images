FROM ubuntu:22.04 as build

ARG crystalcommit=2d46273f

RUN apt update && apt install -y build-essential git

RUN git clone https://github.com/vlang/v 

WORKDIR /v
RUN make 
RUN ./v symlink
RUN mkdir -p /root/.vmodules/freeflowuniverse

WORKDIR /
RUN git clone https://github.com/freeflowuniverse/crystallib.git

WORKDIR /crystallib
RUN git checkout $crystalcommit

WORKDIR /
RUN ln -s /crystallib/crystallib /root/.vmodules/freeflowuniverse

RUN git clone https://github.com/freeflowuniverse/webcomponents.git
RUN ln -s /webcomponents/webcomponents /root/.vmodules/freeflowuniverse

WORKDIR /crystallib/cli/hero
RUN v -cg -enable-globals -w -cflags -static -cc gcc hero.v

FROM ghcr.io/scottyeager/ubuntu:22.04

COPY --from=build /crystallib/cli/hero/hero /usr/local/bin/hero

# A few of these are for optional hero features, but hero will install all
# packages from this list in the course of a basic mdbook operation
RUN apt update && apt install -y --no-install-recommends \
				 curl \
				 redis \
				 build-essential \
				 openssl \
				 libssl-dev \
				 pkg-config \
				 iputils-ping \
				 net-tools \
				 rsync \
				 mc \
				 tmux \
				 libsqlite3-dev \
				 xz-utils \
				 git \
				 git-lfs \
				 imagemagick \
    && rm -rf /var/lib/apt/lists/*

# Hero's gonna try to write to this file, so it better exist
RUN mkdir /root/.ssh
RUN touch /root/.ssh/known_hosts

# Install Rust, mdbook, and plugins
# Do it all in one layer and remove toolchain at the end to keep image slim
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y && \
    . "$HOME/.cargo/env" && \
    cargo install mdbook mdbook-mermaid mdbook-echarts mdbook-kroki-preprocessor && \
    cargo install mdbook-pdf --features fetch && \
    rustup toolchain remove stable-x86_64-unknown-linux-gnu

ENV PATH="/root/.cargo/bin:${PATH}"

# Enable auto ssh-agent when we start bash
COPY bashrc /
RUN cat /bashrc >> /root/.bashrc && rm /bashrc

RUN mkdir -p /etc/zinit
COPY zinit /etc/zinit
