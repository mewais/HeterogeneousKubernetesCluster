# Heterogeneous Kubernetes Cluster
This is my attempt at creating a high availability, heterogeneous kubernetes cluster, consisting of CPUs (ARM and x86_64), FPGAs, GPUs, and storage. This is still a work in progress, so be careful when using.
I tried to script as much as I can of the process itself. This assumes that the our subnet is 10.10.0.0/16.

This was tested using Ubuntu Server 18.04, it has the following topology:
- 3 master nodes, providing high availability if one or more fails, these nodes also host the etcd service, and they use keepalived for load balancing which gives them a virtual master IP. The number of masters can easily be increased by adding/deleting `master-0n_setup.sh` files and modifying the priority numbers in them.
- 3 worker nodes that also serve as storage nodes, these serve as normal workers, but they also host Ceph cloud storage for persistent storage across our cluster. These can also be easily increased by adding more `storage-worker-xx` to the `hosts` file and running `worker_setup.sh` on them. By default, ceph will use `/dev/sdb` on all `storage-worker-xx` nodes, if you want to change the disks you will have to modify `deployments/storage/gen_devices.sh` or `deployments/storage/devices.yaml`.
- 4 worker nodes, the number of those can also increase or decrease by adding/removing them to the `hosts` file and running `worker_setup.sh` on them.
- 3 FPGA nodes, currently this was only tested with Xilinx UltraScale+ SoCs, which include ARM64 processors as well as the FPGA. Note that for those to work correctly, the Linux kernel has to support certain kernel modules and network options, you can find a linux config file in `utils/linux-xlnx/defconfig` that works well for kernel version 4.14.0. As usual, the number of nodes can be increased or decreased like any other worker node.

## How to setup
- run `git clone https://github.com/mewais/KubernetesCluster.git && cd KubernetesCluster`
- The files contain password fields that need to be modified, you can do so by running `grep -rlZPi 'PASSWORD' | xargs -0r perl -pi -e 's/PASSWORD/YOUR_NEW_PASSWORD/gi;'`, obviously change YOUR_NEW_PASSWORD to your password.
- modify your `hosts` file as needed, you may also need to modify the IP addresses in the `master-0n_setup.sh` files.
  - The IPs in the master scripts include the POD IPs, Service IPs, and the virtual master IP
- Copy `hosts` and `master-01_setup.sh` to the first master.
- SSH to the first master and run `./master-01_setup.sh`
  - The script will insert the hosts into the `/etc/hosts` file
  - It will download all the prerequisites, turn off swap, setup keepalived for load balancing, and then initialize the kubernetes cluster.
  - After the script is done, it will generate an `init.log` file which you should keep, it will also generate two shell scripts for adding extra masters and workers.
- Copy `hosts` and `master-02_setup.sh` to the second master.
  - The script will insert the hosts into the `/etc/hosts` file
  - the script will copy the add master script from `master-01` and will ask you for the password (for scp).
- Repeat the same process with `master-03_setup.sh`
  - This is really exactly the same as `master-02_setup.sh`, it just has lower priority for keepalived.
- Copy `hosts` and `worker_setup.sh` to your workers, storage workers, and FPGA workers.
- On each worker, (including the storage and FPGA workers) run `./worker_setup.sh`
  - This will copy the worker join script from master-01 and join the cluster
- On each of the FPGA worker nodes:
  - Follow the prerequisites from the [device plugin repo](https://github.com/mewais/FPGA-K8s-DevicePlugin) to be able to use device plugins.
  - Deploy using the `deployments/devices/fpgas.yaml`
- Copy `~/.kube/config` from `master-01` to your local machine, this allows you to run `kubectl` command from your local machine without having to SSH.
- Visit the `deployments` directory to find some useful deployments, including storage, monitoring, and a local image registry.
  - Currently, and according to [this issue](https://github.com/ceph/ceph-csi/issues/1003), Rook-Ceph storage doesn't have full multiarch support. So for now, it has to be installed before any ARM64 nodes join the cluster.

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
- fpga-worker-01: 10.10.4.1
- fpga-worker-02: 10.10.4.2
- fpga-worker-03: 10.10.4.3

### Pods and Services
- The pods subnet is 10.10.10.0/24
- The service subnet is 10.10.11.0/24

## Deployments
The `deployments` folder includes some useful things that you may be interested in deploying on your cluster, you can visit the directory's `README.md` file for more details.

## Utils
The `utils` folder includes some useful utilities. Including scripts for building, launching, and pausing VMs for testing, configs for ARM Linux kernels to work fine with k8s, and commands to view dashboards.

## TODOs
- Consider using KubeVirt for VMs.
- Add support for nvidia nodes.
