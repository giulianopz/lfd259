## Multi-Container Pods

The idea of multiple containers in a Pod goes against the architectural idea of decoupling as much as possible. But there are certain needs in which a second or third co-located container makes sense:

- **sidecar**: to add some functionality (e.g. logging) not present in the main container
- **adapter**: to modify data, either on ingress or egress, to match some other need
- **ambassador**: allows for access to the outside world without having to implement a service or another entry in an ingress controller
- **initContainer**: allows one or more containers to run only if one or more previous containers run and exit successfully.

## Custom Resources Definitions

The flexibility of Kubernetes allows for dynamic addition of new resources as well. Once these Custom Resources (CRD) have been added, the objects can be created and accessed using standard calls and commands like `kubectl`.

There are two ways to add custom resources to your Kubernetes cluster. The easiest, but less flexible, way is by adding a Custom Resource Definition to the cluster. The second, which is more flexible, is the use of Aggregated APIs, which requires a new API server to be written and added to the cluster.

If the cluster is using Calico, you will find there are several CRDs already in use. More information on the operator framework and SDK can be found on [GitHub](https://github.com/operator-framework). You can also search through existing operators which may be useful on the [OperatorHub website](https://operatorhub.io/).

## Jobs

Just as we may need to redesign our applications to be decoupled, we may also consider that microservices may not need to run all the time. The use of **Jobs** and **CronJobs** can further assist with implementing decoupled and transient microservices.
