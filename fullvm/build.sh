#!/bin/bash

path=$1
name=$(basename $path)

cd $path

# Generates the tar archive
docker buildx build --output=. .
mv img.tar.gz ${name}.tar.gz

# Also tag and save the image
docker buildx build --target=image -t $name .
