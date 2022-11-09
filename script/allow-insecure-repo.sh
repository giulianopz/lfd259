#!/bin/bash

set -e

sudo sed -i "s/# \[\[registry\]\]/[[registry]]/g" /etc/containers/registries.conf

sudo sed -i  "s/# insecure = false/insecure = true/g" /etc/containers/registries.conf

registry_ip=$(k get svc registry -o jsonpath='{.spec.clusterIP}')

sudo sed -i 's/# location = internal-registry-for-example.com\/bar"/location = "'"$registry_ip"':5000"/g' /etc/containers/registries.conf

# https://microk8s.io/docs/registry-private

sudo mkdir -p /var/snap/microk8s/current/args/certs.d/$registry_ip:5000

sudo touch /var/snap/microk8s/current/args/certs.d/$registry_ip:5000/hosts.toml

sudo bash -c "echo server = '"\"http://$registry_ip:5000"\"' > /var/snap/microk8s/current/args/certs.d/$registry_ip\:5000/hosts.toml"

sudo bash -c "echo [host.'\""$registry_ip:5000"\"'] >> /var/snap/microk8s/current/args/certs.d/$registry_ip\:5000/hosts.toml"

sudo bash -c "echo capabilities = '[\"pull\", \"resolve\"]' >> /var/snap/microk8s/current/args/certs.d/$registry_ip\:5000/hosts.toml"

microk8s stop && microk8s start
