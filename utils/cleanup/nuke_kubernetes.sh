#!/bin/bash

# Stop kubernetes cluster
sudo kubeadm reset
sudo rm -rf /etc/cni/net.d .kube/config

# Nuke IPtables
sudo iptables -F
sudo iptables -F -t nat
sudo iptables -F -t mangle
sudo iptables -X
sudo iptables -X -t nat
sudo iptables -X -t mangle

# Nuke docker
sudo docker stop $(sudo docker ps -aq)
sudo docker rm $(sudo docker ps -aq)
sudo docker network prune -f
sudo docker rmi -f $(sudo docker images -a -q)
sudo docker volume prune
