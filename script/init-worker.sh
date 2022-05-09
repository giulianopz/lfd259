#!/bin/bash
set -e

# Repeat the previous steps to set a second vm as a worker node naming it as `worker`
multipass launch --network eno1 --name worker -m 3G -d 15G
multipass exec worker -- sudo snap install microk8s --classic
multipass exec worker -- usermod -a -G microk8s $USER
multipass exec worker -- chown -f -R $USER ~/.kube
multipass exec worker -- newgrp microk8s
