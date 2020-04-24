#!/bin/bash

# Prepare the yaml files
cp cluster.yaml final_cluster.yaml
cat devices.yaml >> final_cluster.yaml

# Install the CephFS cluster
kubectl create -f resources.yaml
kubectl create -f operator.yaml
kubectl apply -f final_cluster.yaml

# Cleanup
rm final_cluster.yaml

# Configure Block Storage
kubectl apply -f storageclass.yaml

# Expose dashboard
kubectl create -f dashboard.yaml

# Make storage class default
kubectl patch storageclass rook-ceph-block -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-defaultclass":"true"}}}'
