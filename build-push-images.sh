#!/bin/bash

# This script builds Docker images, pushes them to ghcr, and then converts them
# into flist format on the ThreeFold Hub. We already authenticate into ghcr in
# the workflow, so no need to do it here

# We'll pass in the TF Hub token as a repo secret through the workflow
tfhub_token=$1

# Take a Docker image name and convert it to flist on the TF Hub
tfhub_push () {
  curl -X POST -F image=$1 -H "Authorization: bearer $tfhub_token" https://hub.grid.tf/api/flist/me/docker
}

# Check if any files, excluding READMEs, under a path changed in the last commit
diffed () {
  git diff --name-only HEAD^ HEAD $1 | grep -v README > /dev/null;
}

# Check if any files under a path, excluding READMEs, have changes between
# the last two tags. Intended for a workflow that only runs on tag pushes
diffed_tags () {
  last_tag=$(git describe --tags --abbrev=0)
  previous_tag=$(git describe --tags --abbrev=0 $last_tag^)
  git diff --name-only $last_tag $previous_tag $1 | grep -v README > /dev/null;
}

# Pulls in variables: deb_parents and zinit_version
source config.sh

# First build our apt/deb based distros. The Docker images will also be used as
# bases for many images below, so order matters
if diffed_tags ./deb-base; then
  for parent in ${deb_parents[@]}; do 
    name=ghcr.io/scottyeager/$parent

    docker buildx build ./deb-base \
                        --build-arg PARENT=$parent \
                        --build-arg ZINIT_VERSION=$zinit_version \
                        --tag $name
    docker push $name
    tfhub_push $name
  done
fi

# Now build an image with minimal Docker install based on Ubuntu from above.
# Will also be used as a base in some images below
# Rebuild on changes to the Ubuntu base too
if diffed_tags ./ubuntu-docker || diffed_tags ./deb-base; then
  docker buildx build ./ubuntu-docker \
                      --tag ghcr.io/scottyeager/ubuntu-docker
  docker push ghcr.io/scottyeager/ubuntu-docker
  tfhub_push ghcr.io/scottyeager/ubuntu-docker
fi

# Alpine can also be used as a base image, so build it separately too
if diffed_tags ./alpine; then
  docker buildx build ./alpine \
                      --tag ghcr.io/scottyeager/alpine
  docker push ghcr.io/scottyeager/alpine
  tfhub_push ghcr.io/scottyeager/alpine
fi

# Now build all the rest of the images
# TODO: also rebuild images when base images change
image_dirs=$(ls -d */ | grep -v 'deb-base\|alpine\|ubuntu-docker')

for path in $image_dirs; do
  # Check for changes in any parent and if so rebuild
  rebuild=false
  parent=$path
  while [ -f "${parent}/Dockerfile" ]; do
    if diffed_tags $parent; then
      rebuild=true
      break
    fi
    parent=$(cat ${parent}/Dockerfile | head -n 1 | cut -d / -f 3 | cut -d : -f 1)
  done
  if $rebuild; then
    name=ghcr.io/scottyeager/${path///} # Strip trailing / from paths

    docker buildx build $path \
                      --tag $name
    docker push $name
    tfhub_push $name
  fi
done
