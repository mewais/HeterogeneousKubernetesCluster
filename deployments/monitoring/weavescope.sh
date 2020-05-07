#!/bin/bash

wget "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(kubectl version | base64 | tr -d '\n')" -O scope.yaml
# If you use only x86 comment the following to use latest weave scope image instead
perl -pi -e "s/weaveworks\/scope:.*'/carlosedp\/scope'/gi;" scope.yaml
kubectl apply -f scope.yaml
