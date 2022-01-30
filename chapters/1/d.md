## Expose a Pod

To expose a port on the pod's IP address use `containerPort` in the Pod resource. Beware that this configuration does not interact with the container to determine what port to open. You have to know what port the process inside the container is using.

```
piVersion: v1
kind: Pod
metadata:
name: basicpod
spec:
containers:
- name: webcont
image: nginx
ports: #<--Add this and following line
 - containerPort: 80
```

You should be able to curl the internal IP assigned to the pod that you can get with `kubectl get pod`.

To expose the pod to other nodes and pods in the cluster, create a Service resource with a port and a selector matched by a label in the Pod configuration:
```
apiVersion: v1
kind: Service
metadata:
name: basicservice
spec:
selector:
type: webserver
ports:
- protocol: TCP
 port: 80
---
apiVersion: v1
kind: Pod
metadata:
name: basicpod
labels: #<-- Add this line
type: webserver #<-- and this line which matches selector
spec:
```

You can curl the cluster-internal IP (`ClusterIP`) shown by `kubectl get svc`.

To expose to outside of the cluster, declare a service of type `NodePort`:
```
apiVersion: v1
kind: Service
metadata:
name: basicservice
spec:
selector:
type: webserver
type: NodePort #<--Add this line
ports:
 - protocol: TCP
 port: 80
```

`kubectl get svc` should now display the Node's IP and Node's high port (i.e. the second in the `PORT(S)` column). You'll be able to contact the NodePort Service, from outside the cluster, by requesting `<NodeIP>:<NodePort>`.

Adittionally, you can get the public IP address of the node (e.g. by executing `curl ifconfig.io`) and curl it to test access to the pod.
