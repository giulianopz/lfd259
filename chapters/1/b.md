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
