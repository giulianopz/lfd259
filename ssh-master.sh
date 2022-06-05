#!/bin/bash

set -e
set -x

start() {
        echo "Starting the cluster..."
        systemctl start snap.multipass.multipassd.service
}

sshmaster() {
        echo "Shell into master..."
        multipass shell master
}

if multipass ls; then
        state=$(multipass ls | grep master | tr -s ' ' | cut -d' ' -f2)
        echo "Master node is in state: $state"
        if [ $state != 'Running' ]; then
                start
        fi
else
        start
fi

if multipass ls; then
        sshmaster
else
        echo "Waiting 20 secs for the nodes to be up..."
        sleep 20
        sshmaster
fi
