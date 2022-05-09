#!/bin/bash
secret=$(microk8s kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
microk8s kubectl -n kube-system describe secret $secret | grep -Po "(?<=token:).*" | tr -d ' '
