# WeaveScope
There's a lot of monitoring solutions for Kubernetes, ranging in their capabilities and offering different features. I chose [WeaveScope](https://github.com/weaveworks/scope) as my monitoring solution. Use the command `./monitoring.sh` to run the script, it will deploy WeaveScope on the cluster and forward the cluster's port `4040` to your machine. You can then visit [localhost:4040](localhost:4040) in your browser to view.

## ARM64
If you intent to build an ARM64 cluster, or a hybrid AMD64/ARM64 cluster, comment out the middle part of the script.
