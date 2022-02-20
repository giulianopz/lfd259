#!/bin/bash
set -e

echo "[DEBUG] Disable AppArmor"
sudo systemctl disable --now apparmor.service

echo "[DEBUG] Install AppArmor"
sudo snap install microk8s --classic
echo '[DEBUG] Switch to group microk8s'
sudo usermod -a -G microk8s $USER && sudo chown -f -R $USER ~/.kube && newgrp microk8s
echo "[DEBUG] Enable standard stuff"
microk8s enable dns dashboard storage

echo "[DEBUG] Set alias for kubectl"
sudo snap alias microk8s.kubectl k
echo "source <(k completion bash | sed 's/kubectl/k/g')" >> ~/.bashrc && source ~/.bashrc

exit 0
