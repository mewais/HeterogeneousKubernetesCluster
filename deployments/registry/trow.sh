#!/bin/bash

# https://github.com/ContainerSolutions/trow/blob/master/install/INSTALL.md
# https://blog.container-solutions.com/installing-a-registry-on-kubernetes-quickstart

cd trow-install/
kubectl create namespace trow
kubectl apply -k overlays/example-overlay/
