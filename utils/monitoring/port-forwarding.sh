#!/bin/bash

echo "You can access the dashboard at: "
echo "localhost:4040"
kubectl port-forward -n weave "$(kubectl get -n weave pod --selector=weave-scope-component=app -o jsonpath='{.items..metadata.name}')" 4040
