#!/bin/bash
#Reference: https://ubuntu.com/tutorials/install-a-local-kubernetes-with-microk8s#1-overview

sudo snap install microk8s --classic
sudo ufw allow in on cni0 && sudo ufw allow out on cni0
sudo ufw default allow routed
microk8s enable dns dashboard storage
