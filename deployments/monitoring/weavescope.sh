#!/bin/bash

wget "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(kubectl version | base64 | tr -d '\n')" -O scope.yaml
# If you use a hybrid AMD64/ARM64 or just an ARM64 cluster, uncomment the following
perl -pi -e "s/weaveworks\/scope:.*'/carlosedp\/scope'/gi;" scope.yaml
kubectl apply -f scope.yaml
