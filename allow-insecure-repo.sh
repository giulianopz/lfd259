#!/bin/bash

set -e

sed -i "s/# \[\[registry\]\]/[[registry]]/g" /etc/containers/registries.conf

sed -i  "s/# insecure = false/insecure = true/g" /etc/containers/registries.conf

registry_ip=$(k get svc registry -o jsonpath='{.spec.clusterIP}')

sed -i 's/# location = internal-registry-for-example.com\/bar"/location = '"$registry_ip"':5000/g' /etc/containers/registries.conf
