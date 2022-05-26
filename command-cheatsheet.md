How to apply manifests right from the clipboard using a simple technique:
```
kubectl apply -f -
<ctrl> + v  # paste
<enter>     # flush
<ctrl> + d  # trigger EOF
```
But don't accidentally hit <Ctrl> + d twice: it'll close your bash session

---

How to create Kubernetes manifests using `kubectl create --dry-run=client -o yaml`, e.g.:
```
kubectl create deployment foo --image=nginx:1.21 \
  --dry-run=client \
  -o yaml
```

> Note: `--dry-run` values can be `none`, `server`, or `client`. If `client` strategy, only print the object that would be sent, without sending it. If `server` strategy, submit server-side request without persisting the resource.

The same option can be used with the `run` command:
```
kubectl run nginx --image=nginx --restart=Never \
  --dry-run=client
  -o yaml > pod.yaml
```

Instead of redirecting the output to a file, you can pass it directly to an editor:
```
k create job myjob --image=busybox --dry-run=client -o yaml | vi -
```

Then assign it a name and quit:
```
wq job.yaml
```

---

Create a temporary pod to troubleshoot some issues:
```
kubectl run tmp --image=busybox --restart=Never --rm -it -- /bin/sh
```

---

Delete all evicted pods: `kubectl get pods | grep Evicted | awk '{print $1}' | xargs kubectl delete pod`

---

List packages installed in container:
```
k run test --image=docker.io/library/alpine --restart=Never --rm -it -- apk info -vv
k run test --image=docker.io/ubuntu/nginx --restart=Never --rm -it -- dpkg -l
k run test --image=docker.io/redhat/ubi8-minimal --restart=Never --rm -it -- rpm -qa
k run test --image=registry.access.redhat.com/rhel7 --restart=Never --rm -it -- yum list installed
```
