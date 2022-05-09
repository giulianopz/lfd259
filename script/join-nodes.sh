#!/bin/bash
set -e


# Set a static IP for both multipass instaces, so that you can use the when joining the nodes:
#network:
#    ethernets:
#        default:
#            dhcp4: true
#            match:
#                macaddress: 52:54:00:b9:44:6b # put your MAC address here
#            addresses:
#            -  192.168.1.221/24 # put the static IP here
#        extra0:
#            dhcp4: true
#            dhcp4-overrides:
#                route-metric: 200
#            match:
#                macaddress: 52:54:00:af:b9:bb
#            optional: true
#    version: 2

# Generate a connection string in the master node, this string is a command you can run in the worker to join this worker node to the master

multipass exec master -- sudo microk8s add-node
#From the node you wish to join to this cluster, run the following:
#microk8s join 10.87.132.212:25000/7c920ce61797b78f8796449dbc03dc3c/bd6bdd702477
#
#Use the '--worker' flag to join a node as a worker not running the control plane, eg:
#microk8s join 10.87.132.212:25000/7c920ce61797b78f8796449dbc03dc3c/bd6bdd702477 --worker
#
#If the node you are adding is not reachable through the default interface you can use one of the following:
#microk8s join 10.87.132.212:25000/7c920ce61797b78f8796449dbc03dc3c/bd6bdd702477

# Join the worker to the master:

multipass exec worker -- microk8s join 10.87.132.212:25000/7c920ce61797b78f8796449dbc03dc3c/bd6bdd702477 --worker
