#!/bin/bash

# https://github.com/gluster/gluster-kubernetes/blob/master/docs/setup-guide.md

# Download prerequisites
sudo apt install git

# Download necessary GlusterFS Configs
git clone https://github.com/gluster/gluster-kubernetes.git
cd gluster-kubernetes/deploy/
./gk-deploy -g storage_topology.json
