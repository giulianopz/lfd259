#!/bin/bash
#Reference: https://ubuntu.com/tutorials/install-a-local-kubernetes-with-microk8s#1-overview

sudo snap install microk8s --classic
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
newgrp microk8s
microk8s enable dns dashboard storage


sudo snap alias microk8s.kubectl k
echo "source <(k completion bash | sed 's/kubectl/k/g')" >> ~/.bashrc
source ~/.bashrc

sudosudo microk8s add-node microk8s add-node
From the node you wish to join to this cluster, run the following:
microk8s join 10.87.132.212:25000/7c920ce61797b78f8796449dbc03dc3c/bd6bdd702477

Use the '--worker' flag to join a node as a worker not running the control plane, eg:
microk8s join 10.87.132.212:25000/7c920ce61797b78f8796449dbc03dc3c/bd6bdd702477 --worker

If the node you are adding is not reachable through the default interface you can use one of the following:
microk8s join 10.87.132.212:25000/7c920ce61797b78f8796449dbc03dc3c/bd6bdd702477
