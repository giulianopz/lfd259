#!/bin/bash
set -e

# To expose a web service (e.g. k8s dashboard) from the cluster running within Multipass via its host to another client,
#   1. Ensure that the service is of type NodePort
# k -n kube-system edit service kubernetes-dashboard
# >> type: NodePort                   # change clusterIP to NodePort (if needed)
#   2. Find the high port the service is exposed to:
#  k -n kube-system get services
# >> kubernetes-dashboard NodePort 10.107.194.201 [none] 443:32414/TCP 20d
#   3. Use a local port-forwarding to reach the cluster from your laptop using the VMs host as an SSH server
# ssh -L local-port:multipass-master-ip:web-service-port -N -f username@ssh-server-ip
# e.g. ssh -L 31500:192.168.1.221:31500 -N -f giulianopz@192.168.1.57
# To make the connection permanent, create a static route.

# References:
# - https://ubuntu.com/tutorials/install-a-local-kubernetes-with-microk8s#1-overview
# - https://pancho.dev/posts/multipass-microk8s-cluster/
# - https://plainice.com/microk8s-bash-completion
# - https://multipass.run/docs/additional-networks
# - https://maurow.bitbucket.io/notes/multipass-vm-port-forwarding.html
# - https://www.thegeekdiary.com/how-to-access-kubernetes-dashboard-externally/
