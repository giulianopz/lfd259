## Network Policies

While setting up network policies is done by cluster administrators, it is important to understand how they work and could prevent your microservices from communicating with each other or outside the cluster.

By default, all pods can reach each other: all ingress and egress traffic is allowed. This has been a high-level networking requirement in Kubernetes. However, network isolation can be configured and traffic to pods can be blocked. In newer versions of Kubernetes, egress traffic can also be blocked. This is done by configuring a **NetworkPolicy**.

Not all network providers support the NetworkPolicies kind. A non-exhaustive list of providers with support includes Calico, Romana, Cilium, Kube-router, and WeaveNet.
