# My Personal Kubernetes Cluster
This is my attempt at creating a high availability kubernetes cluster using a bunch of old machines I had or have recently obtained.
I tried to script as much as I can of the process itself. This assumes that the our subnet is 10.1.0.0/16

This was tested using Ubuntu Server 18.04, and uses the stacked masters/etcd topology.

## How to setup
- run `git clone https://github.com/mewais/KubernetesCluster.git && cd KubernetesCluster`
- The files contain password fields that need to be modified, you can do so by running `grep -rlZPi 'PASSWORD' | xargs -0r perl -pi -e 's/PASSWORD/YOUR_NEW_PASSWORD/gi;'`, obviously change YOUR_NEW_PASSWORD to your password.
- Copy `hosts` and `master-01_setup.sh` to the first master.
- SSH to the first master and run `./master-01_setup.sh`
  - The script will insert the hosts into the `/etc/hosts` file
  - It will download all the prerequisites, turn off swap, setup keepalived for load balancing, and then initialize the kubernetes cluster.
  - After the script is done, it will generate an `init.log` file which you should keep, it will also generate two shell scripts for adding extra masters and workers.
- Copy `hosts` and `master-02_setup.sh` to the second master.
  - The script will insert the hosts into the `/etc/hosts` file
  - the script will copy the add master script from host1 and will ask you for the password (for scp).
- Repeat the same process with `master-03_setup.sh`
  - This is really exactly the same as `master-02_setup.sh`, it just has lower priority for keepalived.
- Copy `hosts` and `worker_setup.sh` to you workers
- On each worker, run `./worker_setup.sh`
  - This will copy the worker join script from master-01 and join the cluster

## IPs
### Service
- Gateway: 10.1.0.1

### Masters
- master-01: 10.1.1.1
- master-02: 10.1.1.2
- master-03: 10.1.1.3
- virtual-master: 10.1.1.100

### Workers
- worker-01: 10.1.2.1
- worker-02: 10.1.2.2
- worker-03: 10.1.2.3
- worker-04: 10.1.2.4
- worker-05: 10.1.2.5
- worker-06: 10.1.2.6

### Pods
The pods subnet is 10.2.0.0/16
