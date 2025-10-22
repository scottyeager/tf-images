This image automatically builds a copy of `hero` from source and provides a suitable environment for using it's documentation features. It can use either code from Github or a local copy of herolib.

## Quickstart

First, build the image:

```bash
docker buildx build -t hero-git .
```

A typical run would then look like this, replacing `~/.ssh/id_rsa` with the path to your SSH private key if needed:

```bash
docker run --network host -it -v ~/.ssh/id_rsa:/root/ssh/id_rsa hero-git
```

Once inside the container, you'll have a `hero` binary available and all required dependencies to work on Docusaurus projects.

## SSH Keys

If you want to work on private repos or publish, you will need to add SSH keys to hero. Any SSH key mounted into `/root/ssh` will be added to the ssh-agent inside the container for use by hero.

## Specifying git refs

By default, the `development` branch of herolib from Github will be used. If you want to use a different git ref (branch name, tag, or commit hash), specify it using the `HEROLIB_REF` environment variable:

```bash
docker run --network host -it -v ~/.ssh/id_rsa:/root/ssh/id_rsa -e HEROLIB_REF=my_branch hero-git
```

## Using local herolib

If you are also hacking on herolib and want to use your local copy inside the container, mount it as follows:

```bash
docker run --network host -it -v ~/.ssh/id_rsa:/root/ssh/id_rsa -v ~/threefold/repos/herolib:/opt/herolib_mount hero-git
```

Note that `HEROLIB_REF` will be ignored in this case. Controlling git from outside the container will avoid errors due to "dubious ownership".

## Host networking

Using host networking (`--network host`) as shown above is recommended to be able to access the development server started by hero for documentation projects. Currently port mapping with regular Docker networking is not supported.

## Refresh the git repos

As new changes come into the herolib and docusaurus template repos, you might want to update your image to avoid pulling these changes each time the container starts. The Dockerfile uses stages to provide an efficient way to accomplish this. Just run:

```
docker buildx build --no-cache-filter fetch -t hero .
```

This will use the cached layers for most of the build, but will always fetch the latest changes into the git repos.

## Refresh the bun cache

This image warms the cache of node modules used by bun, to speed Docusaurus runs. You can also invalidate the cache before this step, which will result in the template repo being cloned fresh before caching the node modules again:

```
docker buildx build --no-cache-filter clone -t hero .
```
