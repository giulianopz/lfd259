#!/bin/bash

start() {
  systemctl start snap.multipass.multipassd.service
}

sshmaster() {
  multipass shell master
}

if multipass ls; then
        state=$(multipass ls | grep master | tr -s ' ' | cut -d' ' -f2)
        echo "Master node is in state: $state"
        if [ $state != 'Running' ]; then
                echo "Starting the cluster..." && start
        fi
else
        echo "Starting the cluster..." && start
fi
echo "Waiting 10 secs for the nodes to be up..."
sleep 10
echo "Shell into master"
sshmaster
