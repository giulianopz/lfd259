#!/bin/bash
set -e

# List available interfaces that multipass can connect instances to:
#multipass networks

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
