## Resource Management

The **kube-scheduler**, or a custom scheduler, uses the PodSpec to determine the best node for deployment. In addition to administrative tasks to grow or shrink the cluster or the number of Pods, there are autoscalers which can add or remove nodes or pods, with plans for one which uses cgroup settings to limit CPU and memory usage by individual containers. By default, Pods use as much CPU and memory as the workload requires, behaving and coexisting with other Linux processes. Through the use of resource requests, the scheduler will only schedule a Pod to a node if resources exist to meet all requests on that node. The scheduler takes these and several other factors into account when selecting a node for use. Monitoring the resource usage cluster-wide is not an included feature of Kubernetes. Other projects, like Prometheus, are used instead. In order to view resource consumption issues locally, use: `kubectl describe pod`

CPU requests are made in *CPU units*, each unit being a *millicore*, using mille - the Latin word for thousand. Some documentation uses
millicore, others use * *, but both have the same meaning. Thus, a request for .7 of a CPU would be 700 millicore. Should a container use more resources than allowed, it won't be killed, but will be throttled. If the limits are set to the pod instead of a particular container, all usage of the containers is considered and all containers are throttled at the same time. Each millicore is not evaluated, so using more than the limit is possible. The exact amount of overuse is not definite:
- spec.containers[].resources.limits.cpu
- spec.containers[].resources.requests.cpu

The value of CPUs is not relative. It does not matter how many exist, or if other Pods have requirements. One CPU, in Kubernetes, is
equivalent to:
- AWS vCPU
- GCP Core
- Azure vCore
- Hyperthread on a bare-metal Intel processor with Hyperthreading.

With Docker engine, the `limits.memory` value is converted to an integer value and becomes the value to the `docker run --memory <value> <image>` command. The handling of a container which exceeds its memory limit is not definite. It may be restarted, or, if it asks for more than the memory request seting, the entire Pod may be evicted from the node:
- spec.containers[].resour ces.1imits .memory
- spec.containers[].resources.requests.memory

Container files, logs, and EmptyDir storage, as well as Kubernetes cluster data, reside on the root filesystem of the host node. As storage is a limited resource, you may need to manage it as other resources. The scheduler will only choose a node with enough space to meet the sum of all the container requests. Should a particular container, or the sum of the containers in a Pod, use more than the limit, the Pod will be evicted:
- spec.containers [].resour ces. 1imits.ephemeral-storage
- spec.containers [].resources. requests.ephemeral-storage

> Note: Ephemeral storage is a beta feature in v1.14.

## Labels

Labels allow for objects to be selected, which may not share other characteristics. Labels are how operators, also known as watch-loops, track and manage objects. Selectors are namespace-scoped. Use the --all-namespaces argument to select matching objects in all namespaces.
The labels, annotations, name, and metadata of an object can be found near the top of the output produced by `kubectl get <object-name> -o yaml `.

There are several built-in object labels. For example nodes have labels such as the `arch`, `hostname`, and `os`, which could be used for assigning pods to a particular node, or type of node. The `nodeSelector` entry in the podspec could use this label to cause a pod to be deployed on a particular node.
