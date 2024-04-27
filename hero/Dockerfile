FROM ghcr.io/scottyeager/ubuntu:22.04

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

# Install hero from precompiled binary
RUN wget -O /usr/local/bin/hero https://f003.backblazeb2.com/file/threefold/linux-i64/hero
RUN chmod +x /usr/local/bin/hero

# Hero's gonna try to write to this file, so it better exist
RUN mkdir /root/.ssh
RUN touch /root/.ssh/known_hosts

# Install Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install mdbook and plugins
RUN cargo install mdbook mdbook-mermaid mdbook-echarts mdbook-kroki-preprocessor 
RUN cargo install mdbook-pdf --features fetch

# Enable auto ssh-agent when we start bash
COPY bashrc /
RUN cat /bashrc >> /root/.bashrc && rm /bashrc

RUN mkdir -p /etc/zinit
COPY zinit /etc/zinit
