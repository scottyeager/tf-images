FROM ghcr.io/scottyeager/ubuntu:22.04

# Do it all in one RUN step, so we can clean up package lists once at end
# First add Docker's GPG key. Remove gpg and its dependencies when finished
RUN apt update && apt install -y --no-install-recommends gnupg && \
    install -m 0755 -d /etc/apt/keyrings && \
    wget https://download.docker.com/linux/ubuntu/gpg -O- | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    apt remove -y gpg && apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*

    # Add the repository to Apt sources:
RUN echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > \
    /etc/apt/sources.list.d/docker.list

RUN apt update && \
    # Skip compose and buildx. Users can install later if needed
    apt install --no-install-recommends -y docker-ce docker-ce-cli containerd.io && \
    rm -rf /var/lib/apt/lists/*