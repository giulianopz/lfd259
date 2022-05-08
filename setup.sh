#!/bin/bash
set -e

# Please, note that to enable bridged networking with Multipass you will need:
# - NetworkManager as netplan renderer
# - cloud-init support for Version 2 network config
# - LXD

# Install and configure multipass on the host system:

sudo snap install lxd
sudo snap install multipass
sudo multipass set local.driver=lxd
snap connect multipass:lxd lxd

# List available interfaces that multipass can connect instances to:
multipass networks

# Create the master node (replace `enp3s` with your interface):
multipass launch --network eno1 --name master -m 3G -d 15G

# Install and configure microk8s on the master node:

multipass exec master -- sudo snap install microk8s --classic
multipass exec master -- usermod -a -G microk8s $USER
multipass exec master -- chown -f -R $USER ~/.kube
multipass exec master -- newgrp microk8s
multipass exec master -- microk8s enable dns dashboard storage
#multipass exec master -- (crontab -l 2>/dev/null; echo "@reboot apparmor_parser --replace /var/lib/snapd/apparmor/profiles/snap.microk8s.*") | crontab -

# Set an alias for `kubectl` enabling auto-completion:

multipass exec master -- sudo snap alias microk8s.kubectl k
multipass exec master -- echo "source <(k completion bash | sed 's/kubectl/k/g')" >> ~/.bashrc && source ~/.bashrc

# It seems microk8s store its kubeconfig file in a non-default path. To create a kubeconfig file from the microk8s environment, do the following
multipass exec master -- k config view --raw > $HOME/.kube/config

# Install Helm package
multipass exec master -- curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
multipass exec master -- sudo apt install apt-transport-https --yes
multipass exec master -- echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
multipass exec master -- sudo apt update
multipass exec master -- sudo apt install helm -y

# Repeat the previous steps to set a second vm as a worker node naming it as `worker`
multipass launch --network eno1 --name worker -m 3G -d 15G
multipass exec worker -- sudo snap install microk8s --classic
multipass exec worker -- usermod -a -G microk8s $USER
multipass exec worker -- chown -f -R $USER ~/.kube
multipass exec worker -- newgrp microk8s

# Set a static IP for both multipass instaces, so that you can use the when joining the nodes:
#network:
#    ethernets:
#        default:
#            dhcp4: true
#            match:
#                macaddress: 52:54:00:b9:44:6b # put your MAC address here
#            addresses:
#            -  192.168.1.221/24 # put the static IP here
#        extra0:
#            dhcp4: true
#            dhcp4-overrides:
#                route-metric: 200
#            match:
#                macaddress: 52:54:00:af:b9:bb
#            optional: true
#    version: 2

# Generate a connection string in the master node, this string is a command you can run in the worker to join this worker node to the master

multipass exec master -- sudo microk8s add-node
#From the node you wish to join to this cluster, run the following:
#microk8s join 10.87.132.212:25000/7c920ce61797b78f8796449dbc03dc3c/bd6bdd702477
#
#Use the '--worker' flag to join a node as a worker not running the control plane, eg:
#microk8s join 10.87.132.212:25000/7c920ce61797b78f8796449dbc03dc3c/bd6bdd702477 --worker
#
#If the node you are adding is not reachable through the default interface you can use one of the following:
#microk8s join 10.87.132.212:25000/7c920ce61797b78f8796449dbc03dc3c/bd6bdd702477

# Join the worker to the master:

multipass exec worker -- microk8s join 10.87.132.212:25000/7c920ce61797b78f8796449dbc03dc3c/bd6bdd702477 --worker

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
