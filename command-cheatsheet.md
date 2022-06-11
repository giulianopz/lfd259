How to apply manifests right from the clipboard using a simple technique:
```bash
kubectl apply -f -
<ctrl> + v  # paste
<enter>     # flush
<ctrl> + d  # trigger EOF
```
But don't accidentally hit <Ctrl> + d twice: it'll close your bash session

---

How to create Kubernetes manifests using `kubectl create --dry-run=client -o yaml`, e.g.:
```bash
kubectl create deployment foo --image=nginx:1.21 \
  --dry-run=client \
  -o yaml
```

> Note: `--dry-run` values can be `none`, `server`, or `client`. If `client` strategy, only print the object that would be sent, without sending it. If `server` strategy, submit server-side request without persisting the resource.

The same option can be used with the `run` command:
```bash
kubectl run nginx --image=nginx --restart=Never \
  --dry-run=client
  -o yaml > pod.yaml
```

Instead of redirecting the output to a file, you can pass it directly to an editor:
```bash
k create job myjob --image=busybox --dry-run=client -o yaml | vi -
```

Then assign it a name and quit:
```bash
wq job.yaml
```

---

Create a temporary pod to troubleshoot some issues:
```bash
kubectl run tmp --image=busybox --restart=Never --rm -it -- /bin/sh
```

---

Delete all evicted pods: `kubectl get pods | grep Evicted | awk '{print $1}' | xargs kubectl delete pod`

---

List packages installed in container:
```bash
k run test --image=docker.io/library/alpine --restart=Never --rm -it -- apk info -vv
k run test --image=docker.io/ubuntu/nginx --restart=Never --rm -it -- dpkg -l
k run test --image=docker.io/redhat/ubi8-minimal --restart=Never --rm -it -- rpm -qa
k run test --image=registry.access.redhat.com/rhel7 --restart=Never --rm -it -- yum list installed
```

---

Check last events in all namespaces, in a specific namespace or in the current one (nor args):
```bash
kubectl get events --sort-by=.metadata.creationTimestamp [-A|-n a-specific-namespace]
```

---

Change the current context:
```
kubectl config --kubeconfig=config-demo use-context [my-context]
```
Switch namespace:
```
kubectl config set-context --current --namespace=[my-namespace]
```

---

List roles associated with service accounts:
```
kubectl get rolebindings,clusterrolebindings \
--all-namespaces  \
-o custom-columns='KIND:kind,NAMESPACE:metadata.namespace,NAME:metadata.name,SERVICE_ACCOUNTS:subjects[?(@.kind=="ServiceAccount")].name'
```

---

Remove all Docker cached resources:
```
docker rmi -f $(docker images -a -q)
docker rm -f $(docker ps -a -q)
docker volume rm $(docker volume ls -q)
```
