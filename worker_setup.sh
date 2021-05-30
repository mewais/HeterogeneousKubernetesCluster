#!/bin/bash

# Install prereqs
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt update && sudo apt install -y kubeadm=1.18.2-00 kubelet=1.18.2-00 docker.io keepalived
sudo cp ~/kubelet-amd64 /usr/bin/kubelet

# Enable Docker service
sudo systemctl enable docker.service

# Disable Swap
sudo swapoff -a
sudo sed -i.bak -r 's/(.+swap.+)/#\1/' /etc/fstab

# Disable IPv6, sometimes breaks Calico
echo "net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf

# Define all hosts
cat hosts | sudo tee -a /etc/hosts

# Join Cluster
scp master-01:~/worker_join.sh .
sudo ./worker_join.sh
