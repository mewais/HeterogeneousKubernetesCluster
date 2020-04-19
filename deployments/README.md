# Deployments
This is a collection for useful things that you can deploy on your cluster. These should run fine from any machine that has kubectl configured correctly and pointing to your cluster.

## Storage
Use the `utils/gen_storage_topology.sh` to create a new storage_topology.json based on your `hosts` file. You can then run the storage.sh script to install GlusterFS on your storage nodes.

## Monitoring
There's a lot of monitoring solutions for Kubernetes, ranging in their capabilities and offering different features. I chose [WeaveScope](https://github.com/weaveworks/scope) as my monitoring solution. Use the command `./monitoring.sh` to run the script, it will deploy WeaveScope on the cluster and forward the cluster's port `4040` to your machine. You can then visit [localhost:4040](localhost:4040) in your browser to view.

## Registry
Since kubernetes needs an image registry to download images from, and I'm not comfortable using a public registry for some of my work, I decided that the best solution is to host my own image registry. The script here follows this [great guide](https://blog.container-solutions.com/installing-a-registry-on-kubernetes-quickstart) for deploying [trow](https://github.com/ContainerSolutions/trow) on your kubernetes cluster.
