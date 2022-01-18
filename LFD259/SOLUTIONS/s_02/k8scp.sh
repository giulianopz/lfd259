#!/bin/bash
#/* **************** LFD259:2021-12-09 s_02/k8scp.sh **************** */
#/*
# * The code herein is: Copyright the Linux Foundation, 2022
# *
# * This Copyright is retained for the purpose of protecting free
# * redistribution of source.
# *
# *     URL:    https://training.linuxfoundation.org
# *     email:  info@linuxfoundation.org
# *
# * This code is distributed under Version 2 of the GNU General Public
# * License, which you should have received with the source.
# *
# */
#Version 1.22.1

# Bring node to current versions and install an editor and other software
sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install -y vim nano libseccomp2

# Prepare for cri-o
sudo modprobe overlay
sudo modprobe br_netfilter

echo "net.bridge.bridge-nf-call-iptables = 1" | sudo tee -a /etc/sysctl.d/99-kubernetes-cri.conf
echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.d/99-kubernetes-cri.conf
echo "net.bridge.bridge-nf-call-ip6tables = 1" | sudo tee -a /etc/sysctl.d/99-kubernetes-cri.conf

sudo sysctl --system

# Add an alias for the local system to /etc/hosts
sudo sh -c "echo '$(hostname -i) cp' >> /etc/hosts"

# Set the versions to use
export OS=xUbuntu_18.04

export VERSION=1.22

#Add repos and keys
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /" | sudo tee -a /etc/apt/sources.list.d/cri-0.list

curl -L http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/Release.key | sudo apt-key add -

echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" | sudo tee -a /etc/apt/sources.list.d/libcontainers.list

sudo apt-get update

# Install cri-o
sudo apt-get install -y cri-o cri-o-runc podman buildah

sleep 3

# Fix a bug, may not always be needed
sudo sed -i 's/,metacopy=on//g' /etc/containers/storage.conf


sleep 3

sudo systemctl daemon-reload

sudo systemctl enable crio

sudo systemctl start crio
# In case you need to check status:     systemctl status crio

# Add Kubernetes repo and software
sudo sh -c "echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' >> /etc/apt/sources.list.d/kubernetes.list"

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo apt-get update

sudo apt-get install -y kubeadm=1.22.1-00 kubelet=1.22.1-00 kubectl=1.22.1-00

# Now install the cp using the kubeadm.yaml file from tarball
sudo kubeadm init --config=$(find / -name kubeadm.yaml 2>/dev/null )

sleep 5

echo "Running the steps explained at the end of the init output for you"

mkdir -p $HOME/.kube

sleep 2

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sleep 2

sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "Apply Calico network plugin from ProjectCalico.org"
echo "If you see an error they may have updated the yaml file"
echo "Use a browser, navigate to the site and find the updated file"

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

echo

# Add alias for podman to docker for root and non-root user
echo "alias sudo="sudo "" | tee -a $HOME/.bashrc
echo "alias docker=podman" | tee -a $HOME/.bashrc

# Add Helm to make our life easier
wget https://get.helm.sh/helm-v3.7.0-linux-amd64.tar.gz
tar -xf helm-v3.7.0-linux-amd64.tar.gz
sudo cp linux-amd64/helm /usr/local/bin/

echo
sleep 3
echo "You should see this node in the output below"
echo "It can take up to a minute for node to show Ready status"
echo
kubectl get node
echo
echo
echo "Script finished. Move to the next step"
