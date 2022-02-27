#!/bin/bash
set -e
#To run Kubernetes locally on your laptop you have more than one option(https://blog.flant.com/small-local-kubernetes-comparison/).
#If you are using an Ubuntu-based distro deploy single-node Kubernetes instances with `MicroK8s` on virtual machine launched with `multipass` could be the best solution.

# 1. Install and configure multipass on the host system (lxd is required to enable support for bridged networking):

sudo snap install multipass
sudo multipass set local.driver=lxd
sudo snap install lxd
snap connect multipass:lxd lxd

# 2. List available interfaces that multipass can connect instances to:
multipass networks

# 3. Create the master node (replace `enp3s#with your interface):
multipass launch --network enp3s0 --name master -m 3G

# 4. Install and configure microk8s on the master node:

multipass exec master -- sudo snap install microk8s --classic
multipass exec master -- sudo usermod -a -G microk8s $USER
multipass exec master -- sudo chown -f -R $USER ~/.kube
multipass exec master -- newgrp microk8s
multipass exec master -- microk8s enable dns dashboard storage
multipass exec master -- (crontab -l 2>/dev/null; echo "@reboot apparmor_parser --replace /var/lib/snapd/apparmor/profiles/snap.microk8s.*") | crontab -

# 5. Set an alias for `kubectl` enabling auto-completion:

multipass exec master -- sudo snap alias microk8s.kubectl k
multipass exec master -- echo "source <(k completion bash | sed 's/kubectl/k/g')" >> ~/.bashrc && source ~/.bashrc

# 6. Repeat steps 3-5 to set a second vm as a worker node naming it as `worker`
multipass launch --network enp3s0 --name worker -m 3G
multipass exec worker -- sudo snap install microk8s --classic
multipass exec worker -- sudo usermod -a -G microk8s $USER
multipass exec worker -- sudo chown -f -R $USER ~/.kube
multipass exec worker -- newgrp microk8s
multipass exec worker -- microk8s enable dns dashboard storage
multipass exec worker -- (crontab -l 2>/dev/null; echo "@reboot apparmor_parser --replace /var/lib/snapd/apparmor/profiles/snap.microk8s.*") | crontab -
multipass exec worker -- sudo snap alias microk8s.kubectl k
multipass exec worker -- echo "source <(k completion bash | sed 's/kubectl/k/g')" >> ~/.bashrc && source ~/.bashrc

# 7. Set a static IP for both multipass instaces, so that you can use the when joining the nodes:
#network:
#    ethernets:
#        default:
#            dhcp4: true
#            match:
#                macaddress: 52:54:00:b9:44:6b # put you MAC address here
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

# 8. Generate a connection string in the master node, this string is a command you can run in the worker to join this worker node to the master

multipass exec master -- sudo microk8s add-node
#From the node you wish to join to this cluster, run the following:
#microk8s join 10.87.132.212:25000/7c920ce61797b78f8796449dbc03dc3c/bd6bdd702477
#
#Use the '--worker' flag to join a node as a worker not running the control plane, eg:
#microk8s join 10.87.132.212:25000/7c920ce61797b78f8796449dbc03dc3c/bd6bdd702477 --worker
#
#If the node you are adding is not reachable through the default interface you can use one of the following:
#microk8s join 10.87.132.212:25000/7c920ce61797b78f8796449dbc03dc3c/bd6bdd702477

# 9. Join the worker to the master:

multipass exec worker -- microk8s join 10.87.132.212:25000/7c920ce61797b78f8796449dbc03dc3c/bd6bdd702477 --worker

# References:
# - https://ubuntu.com/tutorials/install-a-local-kubernetes-with-microk8s#1-overview
# - https://pancho.dev/posts/multipass-microk8s-cluster/
# - https://plainice.com/microk8s-bash-completion
# - https://multipass.run/docs/additional-networks
# - https://maurow.bitbucket.io/notes/multipass-vm-port-forwarding.html
