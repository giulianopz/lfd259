## Kubernetes for Developers (LFD259) Study Notes

To run Kubernetes locally on your laptop you have more than one option, e.g. see:
- [Small Kubernetes for your local experiments](https://blog.flant.com/small-local-kubernetes-comparison/)
- [Setting up a Kubernetes cluster](https://www.armosec.io/blog/setting-up-kubernetes-cluster/)

If you are using an Ubuntu-based distro deploy single-node Kubernetes instances with `MicroK8s` on virtual machines launched with `multipass` could be the best solution (see the [script](setup.sh) in this repo).

Additional resources you will need to setup in your cluster to simulate the official course environment:
- a userland implementation of NFS3 like unfsd (see [CreateUNFS.sh](CreateUNFS.sh))
