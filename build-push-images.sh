#!/bin/bash

# This script builds Docker images, pushes them to ghcr, and then converts them
# into flist format on the ThreeFold Hub. We already authenticate into ghcr in
# the workflow, so no need to do it here

# We'll pass in the TF Hub token as a repo secret through the workflow
tfhub_token=$1

# Pulls in variables: deb_parents and zinit_version
source config.sh

for parent in ${deb_parents[@]}; do 
  name=ghcr.io/scottyeager/$parent

  docker buildx build ./deb-base \
                      --build-arg PARENT=$parent \
                      --build-arg ZINIT_VERSION=$zinit_version \
                      --tag $name
  docker push $name
  curl -X POST -F image=$name -H "Authorization: bearer $tfhub_token" https://hub.grid.tf/api/flist/me/docker
done