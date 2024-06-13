# tf-images
This repo is a non fork of [threefoldtech/tf-images](https://github.com/threefoldtech/tf-images), to explore building a fully automated pipeline to generate and push ThreeFold VM images using Github workflows.

Micro VM images are roughly container images in a special format called flist, and they are usually stored at hub.grid.tf. The Hub also provides a convenient tool to convert Docker images that are hosted on the web.

As a more recent development, full VM images in the form of a filesystem archive are also supported. This repo now contains some full VM image builds in Docker, but none of the automation applies to them yet. 

## How this repo works

There are a set of base images that derive from Debian based distros and also Alpine. These images provide SSH access, and in the case of Debian and Ubuntu, Busybox has also been installed.

The base images are used via FROM statements as the foundation for the other images. Some, like `ubuntu-docker` might also be the base for further derivatives.

### Autobuilding

This repo is driven by the `build-push-images.sh` script. It runs via the `publish.yaml` workflow, and is triggered by pushes to the repo.

The script is responsible for the following steps:

1. Determine which images need to be build
2. Build the docker images and push them to ghcr
3. Trigger conversion of those images to flists via TF Hub

#### Scanning changes

To determine which images should be built on each push, the script checks the diff of each folder between the most recent tag and the tag before that. This means that if some files (excluding README) have changed *and* there is a new tag, then a particular image will be built and pushed. In the case of `deb-base` the entire set will be built.

The script also scans the parent images, all the way up to the root, and triggers a build if any parent has changed. In this way, the child images should always reflect the latest state of their parents.

#### Firing the workflow

There are two approaches to firing the workflow. When all is working well, the workflow can be fired only on the push of new tags. However, when the script itself is under development, firing on every push may be more useful to test the updates to the script. In the latter case, build work can be easily duplicated if care is not taken, though that does no harm beyond wasted energy.

Current the version uses semver, but probably a simple incrementing counter would be enough in this case (so far that's how it's used). I think it could also be helpful to have a code in the tag, like a trailing "a", to signal rebuilding all images. This might be desireable from time to time, to update the base software, especially sshd.

#### Authentication

An auth token for TF Hub needs to be added to the repo in order for the final convert step to work. This part isn't documented yet, but you can check the workflow file for a clue.
