## Security

Pods and containers within pods can be given specific security constraints to limit what processes running in containers can do. For example, the UID of the process, the Linux capabilities, and the filesystem group can be limited.

Clusters installed using kubeadm allow pods any possible elevation in privilege by default. For example, a pod could control the nodes networking configuration, disable SELinux, override root, and more. These abilities are almost always limited by cluster administrators.

This security limitation is called a **security context**. It can be defined for the entire pod or per container, and is represented as additional sections in the resources manifests. A notable difference is that Linux capabilities are set at the container level.

To automate the enforcement of security contexts, you can define **PodSecurityPolicies** (PSP), although they are deprecated. The replacement has not fully been decided.

These policies are cluster-level rules that govern what a pod can do, what they can access, what user they run as, etc.

While PSP has been helpful, there are other methods gaining popularity. The **Open Policy Agent** (OPA), often pronounced as "oh-pa", provides a unified set of tools and policy framework. OPA can be deployed as an admission controller inside of Kubernetes, which allows OPA to enforce or mutate requests as they are received. Using the OPA Gatekeeper it can be deployed using Custom Resource Definitions.
