#!/bin/bash

# https://github.com/gluster/gluster-kubernetes/blob/master/docs/setup-guide.md

# Download necessary GlusterFS Configs, We use a non official repo because it applies a fix for a kubernetes version.
# git clone https://github.com/gluster/gluster-kubernetes.git
git clone https://github.com/bertpersyn/gluster-kubernetes.git
cd gluster-kubernetes/deploy/
git checkout k8s117
# TODO: Figure out what keys to put here
./gk-deploy -g ../../storage_topology.json --admin-key admin --user-key user
