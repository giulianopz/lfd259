1. Create a new deployment which uses the nginx image.
```
k create deployment review-six --image=nginx
```

2. Create a new **LoadBalancer** service to expose the newly created deployment. Test that it works:
```
k expose deployment review-six --port=80 --target-port=80 --name=review-six-svc --type=LoadBalancer
```

3. Create a new **NetworkPolicy** called `netblock` which blocks all traffic to pods in this deployment only. Test that all traffic is blocked to deployment::
```
vi netblock.yaml
# apiVersion: networking.k8s.io/v1
# kind: NetworkPolicy
# metadata:
#   name: netblock
#   namespace: default
# spec:
#   podSelector:
#     matchLabels:
#       app: review-six
#   policyTypes:
#   - Ingress
k create -f netblock.yaml
curl http://<CLUSTER-IP>:80
> curl: (28) Failed to connect to <CLUSTER-IP> port 80: Connection timed out
```

4. Update the netblock policy to allow traffic to the pod on port 80 only. Test that you can access the default nginx web page:
```
vi netblock.yaml
# apiVersion: networking.k8s.io/v1
# kind: NetworkPolicy
# metadata:
#   name: netblock
#   namespace: default
# spec:
#   podSelector:
#     matchLabels:
#       app: review-six
#   policyTypes:
#   - Ingress
#   ingress:
#   - ports:
#     - port: 80
k replace -f netblock.yaml
curl http://<CLUSTER-IP>:80
> <!DOCTYPE html>
> <html>
> <head>
> <title>Welcome to nginx!</title>
> <style>
> html { color-scheme: light dark; }
> body { width: 35em; margin: 0 auto;
> font-family: Tahoma, Verdana, Arial, sans-serif; }
> </style>
> </head>
> <body>
> <h1>Welcome to nginx!</h1>
> <p>If you see this page, the nginx web server is successfully installed and
> working. Further configuration is required.</p>
>
> <p>For online documentation and support please refer to
> <a href="http://nginx.org/">nginx.org</a>.<br/>
> Commercial support is available at
> <a href="http://nginx.com/">nginx.com</a>.</p>
>
> <p><em>Thank you for using nginx.</em></p>
> </body>
> </html>
```

5. Find and use the security-review1.yaml file to create a pod:
```
k create -f security-review1.yaml
```

6. View the status of the pod:
```
k get pods
> NAME                         READY   STATUS    RESTARTS        AGE
> securityreview               0/1     Error     2 (22s ago)     32s
```

7. Use the following commands to figure out why the pod has issues.
```
k get pod securityreview
k describe pod securityreview
k logs securityreview
```

8. After finding the errors, log into the container and find the proper id of the nginx user:
```
k delete pod securityreview
vi security-review1.yaml
# apiVersion: v1
# kind: Pod
# metadata:
#   name: securityreview
# spec:
#   securityContext:
#     runAsUser: 2100
#   containers:
#   - name:  webguy
#     image: nginx
#     command:
#       - tail
#       - "-f"
#       - /dev/null
#     securityContext:
#       runAsUser: 3000
#       allowPrivilegeEscalation: false
k craete -f security-review1.yaml
k exec -it securityreview -- /bin/sh
$ cat /proc/1/status
> Name:   tail
> Umask:  0022
> State:  S (sleeping)
> Tgid:   1
> Ngid:   0
> Pid:    1
> PPid:   0
> TracerPid:      0
> Uid:    3000    3000    3000    3000
```

9.  Edit the yaml and re-create the pod such that the pod runs without error:
```
vi security-review1.yaml
# apiVersion: v1
# kind: Pod
# metadata:
#   name: securityreview
# spec:
#   securityContext:
#     runAsUser: 1000
#   containers:
#   - name:  webguy
#     image: nginx
#     securityContext:
#       runAsUser: 0
k create -f security-review1.yaml
```

That should be considered only a workaround since running nginx as a non-root user require some [changes](https://github.com/docker-library/docs/tree/master/nginx#running-nginx-as-a-non-root-user) to the server configuration. Alternatively, check out the official Docker NGINX unprivileged [image](https://hub.docker.com/r/nginxinc/nginx-unprivileged).

> Note: [Bitnami](https://docs.bitnami.com/tutorials/work-with-non-root-containers/) offers non-root container images, including also a non-root [image](https://github.com/bitnami/bitnami-docker-nginx) for NGINX.

> Note: [Openshift](https://developers.redhat.com/blog/2020/10/26/adapting-docker-and-kubernetes-containers-to-run-on-red-hat-openshift-container-platform#) provides a solution to this problem running containers with an arbitrarily assigned user ID (i.e. `USER 1001`).

1.   Create a new **ServiceAccount** called `securityaccount`
```
k create serviceaccount securityaccount
```

1.  Create a **ClusterRole** named `secrole` which only allows create, delete, and list of pods in all apiGroups:
```
vi secrole.yaml
# apiVersion: rbac.authorization.k8s.io/v1
# kind: ClusterRole
# metadata:
#   name: secrole
# rules:
# - apiGroups: [""] # "" indicates the core API group
#   resources: ["pods"]
#   verbs: ["create", "delete", "list"]
k create -f secrole.yaml
```

12. Bind the clusterRole to the serviceAccount:
```
vi secbinding.yaml
# apiVersion: rbac.authorization.k8s.io/v1
# kind: ClusterRoleBinding
# metadata:
#   name: securitybinding
# subjects:
# - kind: ServiceAccount
#   name: securityaccount
#   namespace: default
# roleRef:
#   kind: ClusterRole
#   name: secrole
#   apiGroup: rbac.authorization.k8s.io

```

13. Locate the token of the securityaccount.  Create a file called `/tmp/securitytoken`. Put only the value of `token:` is equal to, a long string that may start with `eyJh` and be several lines long. Careful that only that string exists in the file:
```
k get secret <securityaccount-token-name> -o yaml | grep -Po '(?<=token: ).*' > /tmp/securitytoken
```

14. Remove any resources you have added during this review:
```
for i in *.yaml; do k delete -f $i; done
k delete deployments.apps review-six
```
