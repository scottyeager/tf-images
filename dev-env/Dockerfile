FROM ghcr.io/scottyeager/ubuntu:24.04

# Install curl and apache
RUN apt update && apt install -y curl apache2 apache2-utils git sudo

# Set a shell for www-data user. This is needed so we can run code-server
# as www-data and keep file ownership consistent with apache too
RUN usermod -s /bin/bash www-data

# Enable apache modules
RUN a2enmod cgi alias env

# Create git serving folder
RUN mkdir /var/www/git

# Install code server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Copy apache config files
COPY apache-git.conf /etc/apache2/sites-enabled/
COPY apache-ports.conf /etc/apache2/ports.conf

# Copy zinit files
COPY zinit/* /etc/zinit

# Enable code-server to use /var/www
# Maybe these should be the same folder?
RUN chown -R www-data:www-data /var/www/

COPY scripts /scripts

COPY sudoers /etc/sudoers
