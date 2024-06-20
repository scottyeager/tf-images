terraform {
  required_providers {
    grid = {
      source = "threefoldtech/grid"
    }
  }
}

provider "grid" {
    mnemonics = var.mnemonics
    network = var.network
}

variable "mnemonics" {
    type = string
}

variable "network" {
    type = string
}

locals {
  name = "wgtest"
  flist = "https://hub.grid.tf/scott.3bot/ghcr.io-scottyeager-gluster-etcd-latest.flist"
  node1 = 14
  node2 = 15
  node3 = 16
  timeout1 = 15
  timeout2 = 20
  etcd_initial_cluster = "vm1=http://10.21.2.2:2380,vm2=http://10.21.3.2:2380,vm3=http://10.21.4.2:2380"
  etcd_cluster_token = "cluster1"
  hosts = <<-EOT
    10.21.2.2	vm1
    10.21.3.2	vm2
    10.21.4.2	vm3
  EOT
}


resource "grid_network" "net1" {
  nodes       = [local.node1, local.node2, local.node3]
  ip_range    = "10.21.0.0/16"
  name        = local.name
  description = "network"
}

resource "grid_deployment" "d1" {
  name         = local.name
  node         = local.node1
  network_name = grid_network.net1.name
  disks {
    name = "data"
    size = 20
    description = "glusterfs data disk"
  }
  vms {
    name       = "vm1"
    flist      = local.flist
    cpu        = 2
    memory     = 1024
    publicip   = false
    publicip6  = true
    entrypoint = "/sbin/zinit init"
    env_vars = {
      SSH_KEY = file("~/.ssh/id_rsa.pub")
      LEADER = "true"
      ME = "vm1"
      PEER1 = "vm2"
      PEER2 = "vm3"
      TIMEOUT1 = local.timeout1
      TIMEOUT2 = local.timeout2
      ETCD_INITIAL_CLUSTER = local.etcd_initial_cluster
      ETCD_CLUSTER_TOKEN = local.etcd_cluster_token
      HOSTS = local.hosts
    }
    mounts {
        disk_name = "data"
        mount_point = "/data/"
    }
  }
}

resource "grid_deployment" "d2" {
  node         = local.node2
  network_name = grid_network.net1.name
  disks {
    name = "data"
    size = 20
    description = "glusterfs data disk"
  }
  vms {
    name       = "vm2"
    flist      = local.flist
    cpu        = 1
    memory     = 1024
    publicip   = false
    publicip6  = true
    entrypoint = "/sbin/zinit init"
    env_vars = {
      SSH_KEY = file("~/.ssh/id_rsa.pub")
      LEADER = "false"
      ME = "vm2"
      PEER1 = "vm1"
      PEER2 = "vm3"
      TIMEOUT1 = local.timeout1
      TIMEOUT2 = local.timeout2
      ETCD_INITIAL_CLUSTER = local.etcd_initial_cluster
      ETCD_CLUSTER_TOKEN = local.etcd_cluster_token
      HOSTS = local.hosts
    }
    mounts {
        disk_name = "data"
        mount_point = "/data/"
    }
  }
}

resource "grid_deployment" "d3" {
  node         = local.node3
  network_name = grid_network.net1.name
  disks {
    name = "data"
    size = 20
    description = "glusterfs data disk"
  }
  vms {
    name       = "vm3"
    flist      = local.flist
    cpu        = 1
    memory     = 1024
    publicip   = false
    publicip6  = true
    entrypoint = "/sbin/zinit init"
    env_vars = {
      SSH_KEY = file("~/.ssh/id_rsa.pub")
      LEADER = "false"
      ME = "vm3"
      PEER1 = "vm1"
      PEER2 = "vm2"
      TIMEOUT1 = local.timeout1
      TIMEOUT2 = local.timeout2
      ETCD_INITIAL_CLUSTER = local.etcd_initial_cluster
      ETCD_CLUSTER_TOKEN = local.etcd_cluster_token
      HOSTS = local.hosts
    }
    mounts {
        disk_name = "data"
        mount_point = "/data/"
    }
  }
}

output "node1_zmachine1_ip" {
  value = grid_deployment.d1.vms[0].ip
}
output "node1_zmachine_computed_public_ip" {
  value = grid_deployment.d1.vms[0].computedip6
}

output "node2_zmachine1_ip" {
  value = grid_deployment.d2.vms[0].ip
}
output "node2_zmachine_computed_public_ip" {
  value = grid_deployment.d2.vms[0].computedip6
}

output "node3_zmachine1_ip" {
  value = grid_deployment.d3.vms[0].ip
}
output "node3_zmachine_computed_public_ip" {
  value = grid_deployment.d3.vms[0].computedip6
}
