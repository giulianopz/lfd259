#!/bin/bash
#/* **************** LFD259:2021-12-09 s_02/k8scp-docker.sh **************** */
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
# Bring node to current versions and install an editor and other software
sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install -y vim nano 


# Add an alias for the local system to /etc/hosts
sudo sh -c "echo '$(hostname -i) k8scp' >> /etc/hosts"


# Install cri-o
sudo apt-get install -y docker.io

sleep 3


# Add Kubernetes repo and software 
sudo sh -c "echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' >> /etc/apt/sources.list.d/kubernetes.list"

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo apt-get update

sudo apt-get install -y kubeadm=1.21.1-00 kubelet=1.21.1-00 kubectl=1.21.1-00

# Now install the cp using the kubeadm.yaml file from tarball
sudo kubeadm init --config=$(find / -name kubeadm-docker.yaml 2>/dev/null )

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


# Add Helm to make our life easier
wget https://get.helm.sh/helm-v3.5.4-linux-amd64.tar.gz
tar -xf helm-v3.5.4-linux-amd64.tar.gz
sudo cp linux-amd64/helm /usr/local/bin/

echo
sleep 3
echo "You should see this node in the output below"
echo "It can take up to a mintue for node to show Ready status"
echo
kubectl get node
echo
echo
echo
echo "This is the line from /etc/hosts to add to the worker node /etc/hosts:"
grep k8scp /etc/hosts
echo
echo
echo "Script finished. Move to the next step"




