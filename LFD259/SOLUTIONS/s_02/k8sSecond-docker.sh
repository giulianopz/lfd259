#!/bin/bash
#/* **************** LFD259:2021-12-09 s_02/k8sSecond-docker.sh **************** */
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
# Script to install a worker of the cluster
# Bring node to current versions and install an editor and other software
sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install -y vim nano 

# Install docker
sudo apt-get install -y docker.io

# Add Kubernetes repo and software 
sudo sh -c "echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' >> /etc/apt/sources.list.d/kubernetes.list"

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo apt-get update

sudo apt-get install -y kubeadm=1.21.1-00 kubelet=1.21.1-00 kubectl=1.21.1-00

echo
echo "Script finished. Move to the next step"
echo
echo "Edit /etc/hosts and set the cp IP address for the k8scp alias"
echo
echo "You will need to type sudo then copy the entire *kubeadm join*"
echo "command from the cp to this worker."
echo
