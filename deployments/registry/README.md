# Registry
Since kubernetes needs an image registry to download images from, and I'm not comfortable using a public registry for some of my work, I decided that the best solution is to host my own image registry. The script here follows this [great guide](https://blog.container-solutions.com/installing-a-registry-on-kubernetes-quickstart) for deploying [trow](https://github.com/ContainerSolutions/trow) on your kubernetes cluster.