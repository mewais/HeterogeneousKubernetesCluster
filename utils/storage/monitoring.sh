#!/bin/bash

echo "Your password is: "
kubectl -n rook-ceph get secret rook-ceph-dashboard-password -o jsonpath="{['data']['password']}" | base64 --decode && echo

echo "And your dashboard is at: "
PORT=$(kubectl -n rook-ceph get service | grep external | tr -s ' ' | cut -d" " -f5 | cut -d":" -f2 | cut -d"/" -f1)
echo "10.10.1.100:$PORT"
