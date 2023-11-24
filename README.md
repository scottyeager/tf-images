# tf-images
This repo is a non fork of [threefoldtech/tf-images](https://github.com/threefoldtech/tf-images), to explore building a fully automated pipeline to generate and push ThreeFold micro VM images using Github workflows.

Micro VM images are roughly container images in a special format called flist, and they are usually stored at hub.grid.tf. The Hub also provides a convenient tool to convert Docker images that are hosted on the web.

Therefore, our flow can look something like this:

1. Build a Dockerfile
2. Push resulting Docker image to GHCR
3. Trigger conversion by TF Hub

There are a few additional considerations:

* We don't want to build the whole repo on every push. Rather, use some logic to detect which folders contain changed files (not counting README.md) and only build and push those images
* Want to use some templating to build multiple images from same Docker file (different versions of Ubuntu, at least, and maybe all Debian derivatives). Would be nice that the specific versions to build aren't buried in a workflow file (put a config file in the folder instead?)
* Majority of images come `FROM` an Ubuntu parent image we will generate, thus need an order of operations to do them first
