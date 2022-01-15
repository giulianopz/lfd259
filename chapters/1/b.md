## 2. Terminology
---

We have learned that Kubernetes is an orchestration system to deploy and manage containers. Containers are not managed individually; instead, they are part of a larger object called a Pod. A **Pod** consists of one or more containers which share an IP address, access to storage and namespace. Typically, one container in a Pod runs an application, while other containers support the primary application.

**Orchestration** is managed through a series of **watch-loops**, also known as operators or controllers. Each operator interrogates the kube-apiserver for a particular object state, modifying the object until the declared state matches the current state. The default, newest, and feature-filled operator for containers is a **Deployment**. A Deployment deploys and manages a different operator called a ReplicaSet. A **replicaSet** is an operator which deploys multiple pods, each with the same spec information. These are called replicas.

To easily manage thousands of Pods across hundreds of nodes can be difficult. To make management easier, we can use **labels**, arbitrary strings which become part of the object metadata. These are **selectors** which can then be used when checking or changing the state of objects without having to know individual names or UIDs. Nodes can have **taints**, an arbitrary string in the node metadata, to inform the scheduler on Pod assignments used along with toleration in Pod metadata, indicating it should be scheduled on a node with the particular taint.

While using lots of smaller, commodity hardware could allow every user to have their very own cluster, often multiple users and teams share access to one or more clusters. This is referred to as **multi-tenancy**. Some form of isolation is necessary in a multi-tenant cluster, using a combination of the following, which we introduce here but will learn more about in the future:

- namespace, a segregation of resources, upon which resource quotas and permissions can be applied
- context, a combination of user, cluster name and namespace
- resource limits
- pod security policies, limit the ability of pods to elevate permissions or modify the node upon which they are scheduled
- network policies, the ability to have an inside-the-cluster firewall.

---

## Control Plane Node

The Kubernetes master runs various server and manager processes for the cluster. Among the components of the master node are the **kube-apiserver**, the **kube-scheduler**, and the **etcd** database. As the software has matured, new components have been created to handle dedicated needs, such as the **cloud-controller-manager**; it handles tasks once handled by the **kube-controller-manager** to interact with other tools, such as Rancher or DigitalOcean for third-party cluster management and reporting.

There are several add-ons which have become essential to a typical production cluster, such as DNS services. Others are third-party solutions where Kubernetes has not yet developed a local component, such as cluster-level logging and resource monitoring.

---

## Worker Nodes

All worker nodes run the kubelet and kube-proxy, as well as the container engine, such as Docker or [cri-o](https://cri-o.io/). Other management daemons are deployed to watch these agents or provide services not yet included with Kubernetes.

The **kubelet** interacts with the underlying Docker Engine also installed on all the nodes, and makes sure that the containers that need to run are actually running. Should a Pod require access to storage, Secrets or ConfigMaps, the kubelet will ensure access or creation.

The **kube-proxy** is in charge of managing the network connectivity to the containers. It does so through the use of iptables entries.

Kubernetes does not have cluster-wide logging yet. Instead, another CNCF project is used, called [Fluentd](https://www.fluentd.org/). When implemented, it provides a unified logging layer for the cluster, which filters, buffers, and routes messages.
Cluster-wide metrics is not quite fully mature, so [Prometheus](https://prometheus.io/) is also often deployed to gather metrics from nodes and perhaps some applications.

---

## Pod

The whole point of Kubernetes is to orchestrate the life cycle of a container. It does not interact with particular containers. Instead, the smallest unit we can work with is a Pod. Due to shared resources, the design of a Pod typically follows a **one-process-per-container** architecture.

Containers in a Pod are started in parallel by default. As a result, there is no way to determine which container becomes available first inside a Pod. **initContainers** can be used to ensure some containers are ready before others in a pod. To support a single process running in a container, you may need logging, a proxy, or special adapter. These tasks are often handled by other containers in the same Pod. You may find the term **sidecar** for a container dedicated to performing a helper task.

There is only one IP address per Pod with most network plugins. HPE Labs created a plugin which allows more than one IP per pod. As a result, if there is more than one container, they must share the IP. To communicate with each other, they can use IPC, the loopback interface, or a shared filesystem.

Pods and other objects can be created in several ways. They can be created by using a **generator**, which, historically, has changed with each release:
`$ kubectl run newpod --image=nginx --generator=run-pod/v1`

Or, they can be created and deleted using properly formatted JSON or YAML files:
```
$ kubectl create -f newpod.yaml
$ kubectl delete -f newpod.yaml
```

---

## Services

A Service is a microservice handling a particular bit of traffic, such as a single NodePort or a LoadBalancer to distribute inbound requests among many Pods.

A service, as well as kubectl, uses a selector in order to know which objects to connect. There are two selectors currently supported:

- equality-based, filters by label keys and their values.
  - Three operators can be used, such as `=`, `==`, and `!=`.
  - If multiple values or keys are used, all must be included for a match.
- set-based, filters according to a set of values. The operators are `in`, `notin`, and `exists`.
  - For example, the use of `status notin (dev, test, maint)` would select resources with the key of status which did not have a value of `dev`, `test`, nor `maint`.

---

## Operators

An important concept for orchestration is the use of operators. These are also known as watch-loops and controllers. They query the current state, compare it against the spec, and execute code based on how they differ. Various operators ship with Kubernetes, and you can create your own, as well. A simplified view of an operator is an agent, or Informer, and a downstream store.
