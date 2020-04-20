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
