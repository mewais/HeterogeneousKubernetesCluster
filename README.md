# My Personal Kubernetes Cluster
This is my attempt at creating a high availability kubernetes cluster using a bunch of old machines I had or have recently obtained.
I tried to script as much as I can of the process itself. This assumes that the our subnet is 10.10.0.0/16

This was tested using Ubuntu Server 18.04, it has the following topology:
- 3 master nodes, providing high availability if one or more fails, these nodes also host the etcd service, and they use keepalived for load balancing which gives them a virtual master IP. The number of masters can easily be increased or decreased by adding/deleting `master-0n_setup.sh` files and modifying the priority numbers in them.
- 3 worker nodes that also serve as storage nodes, these serve as normal workers, but they also host GlusterFS cloud storage for persistent storage across our cluster. These can also be easily increased by running `storage-worker_setup.sh` on more nodes. Unfortunately they cannot be decreased as the minimum for GlusterFS and Heketi is 3 nodes.
- 4 worker nodes. Just like before, the number of those can also increase or decrease by running `worker_setup.sh` on more or less nodes.

## How to setup
- run `git clone https://github.com/mewais/KubernetesCluster.git && cd KubernetesCluster`
- The files contain password fields that need to be modified, you can do so by running `grep -rlZPi 'PASSWORD' | xargs -0r perl -pi -e 's/PASSWORD/YOUR_NEW_PASSWORD/gi;'`, obviously change YOUR_NEW_PASSWORD to your password.
- modify your `hosts` file as needed, you may also need to modify the IP addresses in the `master-0n_setup.sh` files.
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
- Copy `hosts` and `worker_setup.sh` to your workers and storage workers
- On each worker (and storage worker), run `./worker_setup.sh`
  - This will copy the worker join script from master-01 and join the cluster
- You can use the utility script `gen_storage_topology.sh` to create a new `storage_topology.json` based on your modified `hosts` file.
- Copy `storage-worker_setup.sh` and `storage_topology.json` to your master
- SSH to the master and run `storage-worker_setup.sh`
- Copy `~/.kube/config` from `master-01` to your local machine, this allows you to run `kubectl` command from your local machine without having to SSH.

## IPs
### Service
- Gateway: 10.10.0.1

### Masters
- master-01: 10.10.1.1
- master-02: 10.10.1.2
- master-03: 10.10.1.3
- virtual-master: 10.10.1.100

### Workers
- storage-worker-01: 10.10.2.1
- storage-worker-02: 10.10.2.2
- storage-worker-03: 10.10.2.3
- worker-01: 10.10.3.1
- worker-02: 10.10.3.2
- worker-03: 10.10.3.3
- worker-04: 10.10.3.4

### Pods
The pods subnet is 10.10.10.0/16

## Deployments
The `deployments` folder includes some useful things that you may be interested in deploying on your cluster, you can visit the directory's `README.md` file for more details.

## TODOs
Add support for nvidia nodes.
