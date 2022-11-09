## Kubernetes for Developers (LFD259) Study Notes to Prepare for the CKAD Certification Exam

### 1. Local Environment Setup

To follow the labs of this course you will have to run Kubernetes somehow. The course suggests to deploy a two-node cluster with `kubeadm` on any platform of your choice (VirtualBox, VMWare, AWS, GCE or even bare metal).

For [CKAD](https://training.linuxfoundation.org/certification/certified-kubernetes-application-developer-ckad/) actually, running locally Kubernestes as single-node on your laptop can be enough and you have more than one option, e.g. see:
- [Small Kubernetes for your local experiments](https://blog.flant.com/small-local-kubernetes-comparison/)
- [Setting up a Kubernetes cluster](https://www.armosec.io/blog/setting-up-kubernetes-cluster/)[^1]

If you have a spare/old laptop or a server/mini-pc, you can setup a mini cluster consisting of two nodes (master + worker) launching `multipass` instances (using `LXD` as backend) which run `MicroK8s` (using `containerd` as container runtime). See the following image for the network topology of such configuration:

<p align="center">
    <img src="mini-cluster-netword-diagram.jpg"/>
</p>

The scripts in the `/script` dir roughly scketch how to bootstrap the minicluster.

You will need some additional stuff to simulate the official course environment in your cluster:
- a SSH-tunnel to reach from your laptop the service exposed from the cluster passing through the host system: `ssh -L local-port:multipass-master-ip:web-service-port -N -f username@ssh-server-ip`
- a user-land implementation of **NFSv3** like `unfsd` (see [CreateUNFS.sh](CreateUNFS.sh)): but it can be tricky, since you are not allowed two turn multipass instances into LXD privileged containers
  - alternatively, consider to just mount a directory from the host as follows: `multipass mount -u $UID:1000 ckad/ master:/mnt`
- a **linkerd** service-mesh installed with version `stable-2.10.0` (more recent versions will not work with latest ingress-nginx version you will be required to install)
  - otherwise use the microk8s specific [add-on](https://microk8s.io/docs/addon-linkerd)

Please, be aware that this setup has some limitations:
- a `dnsPolicy: Default` in a Pod specs causes domain name resolution failures
  - you may consider the first option listed [here](https://gist.github.com/superseb/f6894ddbf23af8e804ed3fe44dd48457#file-defaultdns-md) to get around the issue:
  ```
  :~$ sudo systemctl mask systemd-resolved
  :~$ rm -f /etc/resolv.conf
  :~$ sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
  ```
- multipass crashes on startup if network is unavailable (this bug should fixed now in newer versions), you will have to restart the multipass daemon manually:
  ```
  :~$ sudo systemctl start snap.multipass.multipassd.service
  ```

### 2. Study and Practice for CKAD

Attending the LFD259 course and completing the relative labs is not enough: the course itslef is just a prompt to study deeper the official Kubernetes docs: see [here](bookmarks.html) the most important pages bookmarked.

You will also need to practice a lot by going through additional hands-on labs besides the ones offered by the LFD259 course: see [here](references.md#practice-material) the available options to practice online or on your mini-cluster.

> Note: If you have bought the exam from The Linux Foundation, you get for free two attempts at the official [simulator](https://killer.sh/) of the exam.

To plan your study strategy in view of the exam:
- review the [syllabus](syllabus.md) of the domains covered by the exam
- consult the [references](references.md) on how to effectively prepare for the exam
- internalize the [tricks](tricks.md) you can use from the CLI

### 3. Tips

Before sitting the exam:
- read the [candidate handbook](https://docs.linuxfoundation.org/tc-docs/certification/lf-candidate-handbook) and the [instructions](https://docs.linuxfoundation.org/tc-docs/certification/tips-cka-and-ckad) of the exam
- make sure you have bookmarked the pages of the official Kubernetes docs where you can quickly find example of valid manifests to create objects/resources
  - if you have not yet collected this stuff, see [here](bookmarks.html)
- remember how to set autocompletion for the `kubectl` command and its alias (just in case, since it should be already configured so):
  ```
  :~$ echo 'source <(kubectl completion bash)' >> ~/.bashrc
  :~$ echo 'alias k=kubecstl' >> ~/.bashrc
  :~$ echo 'complete -F __start_kubectl k' >> ~/.bashrc
  ```
  - generally, avoiding to use/hardcode too many aliases/variables in your shell will help you to build up "muscle memory"
- be aware that copying-pastying should be facilitated by simply selecting text and then right-clicking on the terminals
- get familiar with the commands available in the exam environment:
  - `vi/vim` to edit files
  - `jq` to process JSON/YAML files
    - you can validate a YAML file by simply typing: `cat invalid.yaml | jq empty`
  - `curl/wget` to call webservers
    - always use a flag to set the timeout in order to not hang the terminal for too long:
    ```
    curl --connect-timeout 3 [IP:PORT]
    wget --spider --timeout 3 [IP:PORT]
    ```
  - `man` or `[command] -h/--help` to consult commands' manuals
- have a try with the [simulator](https://killer.sh/)

[^1]: Alternatively, you may take into considerations online Kubernetes playgrounds such as the followings (not recommended): [Play with Kubernetes](https://labs.play-with-k8s.com/), [Katacoda](https://www.katacoda.com/courses/kubernetes/playground)
