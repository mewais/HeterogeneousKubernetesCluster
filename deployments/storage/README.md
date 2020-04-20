# CephFS Storage

The scripts used here are based on [this article](https://itnext.io/deploy-a-ceph-cluster-on-kubernetes-with-rook-d75a20c3f5b1) with some modifications. It uses some yaml files from [the rook repo](https://github.com/rook/rook) release 1.13.

## Deployment
- If you haven't already, follow the main README file and setup your control machine.- If you have modified your `hosts` file, use the script `gen_devices.sh` to create a `devices.yaml` file, which will be later used. The created file assumes `/dev/sdb` is the target device on all storage nodes. You might have to manually modify `devices.yaml` if you want to use other/more devices.
- run the `ceph.sh`, this will install the CephFS cluster, create StorageClass and PersistentVolumeClaim
