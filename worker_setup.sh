#!/bin/bash

# Install prereqs
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt update && sudo apt install -y kubeadm kubelet docker.io

# Enable Docker service
sudo systemctl enable docker.service

# Disable Swap
sudo swapoff -a
sudo sed -i.bak -r 's/(.+swap.+)/#\1/' /etc/fstab

# Define all hosts
cat hosts | sudo tee -a /etc/hosts

# Join Cluster
scp master-01:~/worker_join.sh .
sudo ./worker_join.sh
