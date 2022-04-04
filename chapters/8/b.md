## Basic Troubleshooting

Should the error not be seen while starting the Pod, investigate from within the Pod. A flow working from the application running inside a container to the larger cluster as a whole may be a good idea. Some applications will have a shell available to run commands, for example:
```
kubectl create deployment tester --image=nginx
kubectl exec -ti tester- -- /bin/sh
```

A feature which is still in alpha state, and may change in any way or disappear, is the ability to attach an image to a running process. :
```
kubectl alpha debug registry-6b5bb79c4-jd8fj --image=busybox
```

If the Pod is running, use `kubectl logs pod-name` to view the standard out of the container. Without logs, you may consider deploying a sidecar container in the Pod to generate and handle logging.

The next place to check is networking, including DNS, firewalls, and general connectivity, using standard Linux commands and tools.

For pods without the ability to log on their own, you may have to attach a sidecar container.

Assuming the application is not the issue, begin by viewing the pods with the `kubectl get` command. Ensure the pods report a status of Running. A status of Pending typically means a resource is not available from the cluster, such as a properly tainted node, expected storage, or enough resources. Other error codes typically require looking at the logs and events of the containers for further troubleshooting. Also, look for an unusual number of restarts. A container is expected to restart due to several reasons, such as a command argument finishing. If the restarts are not due to that, it may indicate that the deployed application is having an issue and failing due to panic or probe failure.

View the details of the pod and the status of the containers using the `kubectl describe pod` command.

Should the reported information not indicate the issue, the next step would be to view any logs of the container, in case there is a misconfiguration or missing resource unknown to the cluster, but required by the application. These logs can be seen with the `kubectl logs <pod-name> <container-name>` command.

Security settings can also be a challenge. RBAC, SELinux and AppArmor are also common issues, especially with network-centric applications.

Internode networking can also be an issue. Changes to switches, routes, or other network settings can adversely affect Kubernetes. Historically, the primary causes were DNS and firewalls.
