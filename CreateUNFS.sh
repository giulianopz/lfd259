#!/bin/bash
set -e


# From the master
sudo apt-get update && sudo apt-get install -y build-essential flex bison nfs-client curl autoconf

cd /tmp
wget https://github.com/unfs3/unfs3/releases/download/unfs3-0.9.22/unfs3-0.9.22.tar.gz
tar xvf unfs3-0.9.22.tar.gz
./bootstrap && ./configure && make && make install

sudo mkdir /opt/sfw

sudo chmod 1777 /opt/sfw/

sudo bash -c "echo software > /opt/sfw/hello.txt"

# put the IP of your client
sudo bash -c "echo '/opt/sfw/ 192.168.1.222(rw,no_root_squash,insecure)' >> /etc/exports"

# start unfsd
unfsd
# see which ports unfsd ninds to (default is 2049)
# netstat -tunlp | grep unfsd

# test if unfsd can parse the exports file
unfsd -T

echo
echo "Should be ready. Test here and second node"
echo

sudo showmount -e master

# From the host system, ensure nfs mount is enabled in lxd vms
lxc config --project multipass set master raw.apparmor 'mount fstype=nfs*, mount fstype=rpc_pipefs, mount options=(rw, nosuid, noexec, remount, relatime, ro, bind),'
#lxc config  --project multipass show master | grep mount
lxc config --project multipass set worker raw.apparmor 'mount fstype=nfs*, mount fstype=rpc_pipefs, mount options=(rw, nosuid, noexec, remount, relatime, ro, bind),'
#lxc config  --project multipass show worker | grep mount
sudo systemctl reload apparmor

# From the worker
sudo showmount -e master
sudo mount -t nfs -o v3 -vvvv  master:/opt/sfw /mnt
