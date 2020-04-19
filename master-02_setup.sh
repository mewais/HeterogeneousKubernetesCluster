#!/bin/bash

# Install prereqs
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt update && sudo apt install -y kubeadm kubelet docker.io keepalived

# Enable Docker service
sudo systemctl enable docker.service

# Disable Swap
sudo swapoff -a
sudo sed -i.bak -r 's/(.+swap.+)/#\1/' /etc/fstab

# Setup Keepalived for load balancing of masters
# https://medium.com/velotio-perspectives/demystifying-high-availability-in-kubernetes-using-kubeadm-3d83ed8c458b
echo "! Configuration File for keepalived
global_defs {
  router_id LVS_DEVEL
}

vrrp_script check_apiserver {
  script \"/etc/keepalived/check_apiserver.sh\"
  interval 3
  weight -2
  fall 10
  rise 2
}

vrrp_instance VI_1 {
    state BACKUP
    interface enp0s3
    virtual_router_id 51
    priority 90
    authentication {
        auth_type PASS
        auth_pass PASSWORD
    }
    virtual_ipaddress {
        10.10.1.100
    }
    track_script {
        check_apiserver
    }
}" | sudo tee /etc/keepalived/keepalived.conf
echo "
#!/bin/sh

errorExit() {
    echo \"*** \$*\" 1>&2
    exit 1
}

curl --silent --max-time 2 --insecure https://localhost:6443/ -o /dev/null || errorExit \"Error GET https://localhost:6443/\"
if ip addr | grep -q 10.10.1.100; then
    curl --silent --max-time 2 --insecure https://10.10.1.100:6443/ -o /dev/null || errorExit \"Error GET https://10.10.1.100:6443/\"
fi" | sudo tee /etc/keepalived/check_apiserver.sh
tail -n +2 /etc/keepalived/check_apiserver.sh > check_apiserver.tmp
sudo mv check_apiserver.tmp /etc/keepalived/check_apiserver.sh
sudo chmod +x /etc/keepalived/check_apiserver.sh

# Restart Keepalived for the configuration to take place
sudo systemctl restart keepalived

# Define all hosts
cat hosts | sudo tee -a /etc/hosts

# Join Control Plane
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/
scp master-01:~/master_join.sh .
sudo ./master_join.sh

# Copy the kube config file
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
