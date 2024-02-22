#!/bin/bash

# Build the image from Dockerfile
docker buildx build -t ubuntu:gridfullvm .

# Extract image into tar archive
container=$(docker create ubuntu:gridfullvm bash)
docker export $container --output=ubuntu-fullvm.tar
docker rm $container

# Run touchup script, using Docker to avoid `sudo`
container=$(docker create --entrypoint /touchup.sh ubuntu)
docker cp ubuntu-fullvm.tar $container:/
docker cp touchup.sh $container:/
docker start -a $container
docker cp $container:/ubuntu-fullvm.tar.gz ./
docker rm $container
rm ubuntu-fullvm.tar
