#!/bin/bash
set -e

# Please, note that to enable bridged networking with Multipass you will need:
# - NetworkManager as netplan renderer
# - cloud-init support for Version 2 network config
# - LXD

# Install and configure multipass on the host system:
sudo snap install lxd
sudo snap install multipass
sudo multipass set local.driver=lxd
snap connect multipass:lxd lxd
