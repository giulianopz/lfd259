#!/bin/bash
ip=$(microk8s kubectl get all --all-namespaces | grep service/kubernetes-dashboard | tr -s " " | cut -d " " -f4)
firefox https://$ip:443 $
