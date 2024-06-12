# alpine-3

## what in this image
- based on official docker alpine 3
- include preinstalled openssh package.

## Building

in the alpine-3 directory

`docker build -t {user|org}/grid3_alpine:3 .`

## Testing
### Running

```bash
docker run -dti -e SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDL/IvQhp..." {user|org}/grid3_alpine:3
```

### Access using SSH
```bash
CONTAINER_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker container ls -lq))
ssh root@$CONTAINER_IP
```

## Deploying on grid 3

### convert the docker image to Zero-OS flist
Easiest way to convert the docker image to Flist is using [Docker Hub Converter tool](https://hub.grid.tf/docker-convert), make sure you already built and pushed the docker image to docker hub before using this tool.

### Deploying
Easiest way to deploy a VM using the flist is to head to to our [playground](https://play.grid.tf) and deploy a Virtual Machine by providing this flist URL.
make sure to provide the correct entrypoint.

another way you could use is using our terraform plugin [docs](https://github.com/threefoldtech/terraform-provider-grid)

## Flist
### URL:
```
https://hub.grid.tf/tf-official-apps/threefoldtech-alpine-3.flist
```

### Entrypoint
- `/entrypoint.sh`


### Required Env Vars
- `SSH_KEY`: User SSH public key.
