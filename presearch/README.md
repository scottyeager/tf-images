## Info
This dockerfile creates docker image to deploy a presearch node. You only need the Registration code from your presearch account [read here](https://nodes.presearch.org/dashboard) where also you can check your node stats after deployment

The image uses `zinit` a service init manager to start `docker` & `ssh` services, then execute some scripts to run a presearch node

If you have a previous node and want to backup, [read here](https://docs.presearch.org/nodes/backing-up-and-migrating-nodes)
you only need to run this command in your old node
```bash
docker cp presearch-node:/app/node/.keys presearch-node-keys
```
Then give the pair of keys in the created directory `presearch-node-keys` to the env vars `PRESEARCH_BACKUP_PRI_KEY` & `PRESEARCH_BACKUP_PUB_KEY`

## Handled Env Vars
Must: `PRESEARCH_REGISTRATION_CODE`

For restoring old node: `PRESEARCH_BACKUP_PRI_KEY`, `PRESEARCH_BACKUP_PUB_KEY`

For ssh: `SSH_KEY`

## Minimum Hardware requirments
- 1 CPU
- 1 GB RAM 
- 10 GB storage

as [official docs](https://docs.presearch.org/nodes/setup#hardware-specification) suggested.
