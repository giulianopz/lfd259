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

# Make sure packets to/from the pod network interface can be forwarded to/from the default interface on the host via the iptables tool.
sudo iptables -P FORWARD ACCEPT
sudo apt-get install iptables-persistent
sudo systemctl enable --now netfilter-persistent.service
# Please note that the following command will conflict with iptables frontends such as ufw command or firewall-cmd command. 
# Avoid using the following packages if you are using those tools. Alternatively, you can use iptables-save:
#sudo /sbin/iptables-save > /etc/iptables/rules.v4
#sudo /sbin/ip6tables-save > /etc/iptables/rules.v6
