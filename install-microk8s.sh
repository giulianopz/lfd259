#!/bin/bash

sudo systemctl disable --now apparmor.service

sudo snap install microk8s --classic
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
newgrp microk8s
microk8s enable dns dashboard storage

sudo snap alias microk8s.kubectl k
echo "source <(k completion bash | sed 's/kubectl/k/g')" >> ~/.bashrc
source ~/.bashrc
