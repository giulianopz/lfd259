## Expose a Service

The basic step to access a new service is to use kubectl.
```
k expose deployment/nginx --port=80 --type=NodePort
```
> Note: A Service can map any incoming `port` to a `targetPort`. By default and for convenience, the `targetPort` is set to the same value as the `port` field.

Typically, a service creates a new **endpoint** for connectivity. Should you want to create the service, but later add the endpoint, such as connecting to a remote database, you can use a service without **selectors**. This can also be used to direct the service to another service, in a different namespace or cluster.

For inter-cluster communication, frontends talking to backends can use `ClusterIP`s.

`NodePort` is a simple connection from a high-port routed to a ClusterIP using **iptables**, or **ipvs** in newer versions: the NodePort is accessible via calls to `<NodeIP>:<NodePort>`.

Creating a `LoadBalancer` service generates a NodePort, which then creates a ClusterIP. It also sends an asynchronous call to an external load balancer, typically supplied by a cloud provider. The External-IP value will remain in a `<Pending>` state until the load balancer returns. Should it not return, the NodePort created acts as it would otherwise.

The use of an `ExternalName` service, which is a special type of service without selectors, is to point to an external DNS server. Use of the service returns a CNAME record. Working with the ExternalName service is handy when using a resource external to the cluster, perhaps prior to full integration.

**Ingress** exposes HTTP and HTTPS routes from outside the cluster to services within the cluster. Traffic routing is controlled by rules defined on the Ingress **resource**.

An Ingress may be configured to give Services externally-reachable URLs, load balance traffic, terminate SSL/TLS, and offer name-based virtual hosting. An Ingress **controller** is responsible for fulfilling the Ingress, usually with a load balancer, though it may also configure your edge router or additional frontends to help handle the traffic.

There are a few ingress controllers with **nginx** and **GCE** that are "officially supported" by the community. **Traefik** (pronounced "traffic") and **HAProxy** are in common use, as well.

For more complex connections or resources such as service discovery, rate limiting, traffic management and advanced metrics you may want to implement a **service mesh**: it consists of edge and embedded proxies communicating with each other and handing traffic based on rules from a control plane. Various options are available including **Envoy**, **Istio**, and **linkerd**.
