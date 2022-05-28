#!/bin/bash

set timeout 60
set -e

start() {
  systemctl start snap.multipass.multipassd.service
}

sshmaster() {
  multipass shell master
}

state=$(multipass ls | grep master | tr -s ' ' | cut -d' ' -f2)
echo "Master node is in state: $state"
if [ $state != 'Running' ]; then
        echo "Starting the cluster..." && start
fi
echo "Waiting 5 secs for the nodes to be up..."
sleep 5
echo "Shell into master"
sshmaster
