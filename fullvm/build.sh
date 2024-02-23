#!/bin/bash

path=$1
name=$(basename $path)

# Build the image from Dockerfile
pushd $path
docker buildx build -t $name .

# Extract image into tar archive
container=$(docker create $name bash)
docker export $container --output=${name}.tar
docker rm $container

# Run touchup script, using Docker to avoid `sudo`
container=$(docker create -e ARCHIVE=${name}.tar --entrypoint /touchup.sh ubuntu)
docker cp ${name}.tar $container:/
docker cp ../touchup.sh $container:/

docker start -a $container
docker cp $container:/${name}.tar.gz ./

docker rm $container
rm ${name}.tar
popd
