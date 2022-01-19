1. Install and configure multipass on the host system (lxd is required to enable support for bridged networking):
    ```
    you@host:~$ sudo snap install multipass
    you@host:~$ sudo multipass set local.driver=lxd
    you@host:~$ sudo snap install lxd
    you@host:~$ snap connect multipass:lxd lxd
    ```

2. List available interfaces that multipass can connect instances to:
`multipass networks`

3. Create the master node (replace `enp3s0` with your interface):
`multipass launch --network enp3s0 --name master -m 2G`

4. Install and configure microk8s on the master node:
    ```
    you@host:~$ multipass shell master
    ubuntu@master:~$ sudo snap install microk8s --classic
    ubuntu@master:~$ sudo usermod -a -G microk8s $USER
    ubuntu@master:~$ sudo chown -f -R $USER ~/.kube
    ubuntu@master:~$ newgrp microk8s
    ubuntu@master:~$ microk8s enable dns dashboard storage
    ```
5. Set an alias for `kubectl` enabling auto-completion:
    ```
    ubuntu@master:~$ sudo snap alias microk8s.kubectl k
    ubuntu@master:~$ echo "source <(k completion bash | sed 's/kubectl/k/g')" >> ~/.bashrc
    ubuntu@master:~$ source ~/.bashrc
    ```
6. Repeat steps 3-5 to set a second vm as a worker node naming it as `worker`.

7. Generate a connection string in the master node, this string is a command you can run in the worker to join this worker node to the master
    ```
    ubuntu@master:~$ sudo microk8s add-node
    From the node you wish to join to this cluster, run the following:
    microk8s join 10.87.132.212:25000/7c920ce61797b78f8796449dbc03dc3c/bd6bdd702477

    Use the '--worker' flag to join a node as a worker not running the control plane, eg:
    microk8s join 10.87.132.212:25000/7c920ce61797b78f8796449dbc03dc3c/bd6bdd702477 --worker

    If the node you are adding is not reachable through the default interface you can use one of the following:
    microk8s join 10.87.132.212:25000/7c920ce61797b78f8796449dbc03dc3c/bd6bdd702477
    ```
8. Log into worker node and join the worker to the master:
    ```
    you@host:~$ multipass shell worker
    ubuntu@worker:~$ microk8s join 10.87.132.212:25000/7c920ce61797b78f8796449dbc03dc3c/bd6bdd702477 --worker
    ```

References:
- https://ubuntu.com/tutorials/install-a-local-kubernetes-with-microk8s#1-overview
- https://pancho.dev/posts/multipass-microk8s-cluster/
- https://plainice.com/microk8s-bash-completion
- https://multipass.run/docs/additional-networks
- https://maurow.bitbucket.io/notes/multipass-vm-port-forwarding.html
