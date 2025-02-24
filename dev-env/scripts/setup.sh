#!/bin/bash

usermod -aG sudo www-data

# Clone the repository if $GIT_REPO is set, otherwise create a new repo
if [ -n "$GIT_REPO" ] && [[ "$GIT_REPO" =~ ^(https?|git|ssh):// ]]; then
    # Extract repo name
    REPO_NAME=$(basename "$GIT_REPO" .git)
    sudo -u www-data git clone "$GIT_REPO" "/var/www/git/$REPO_NAME"
else
    # Convert spaces to underscores if GIT_REPO is just a name
    FOLDER_NAME=${GIT_REPO:-project}
    FOLDER_NAME=${FOLDER_NAME// /_}
    sudo -u www-data mkdir -p /var/www/git
    cd /var/www/git
    sudo -u www-data git init "$FOLDER_NAME"
fi

# Create a password file based on $PASSWORD
if [ -n "$PASSWORD" ]; then
    sudo -u www-data htpasswd -bc /var/www/git/.htpasswd user "$PASSWORD"
fi
