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
kubectl create deployment foo \
  --image=nginx:1.21 \
  --dry-run=client \
  -o yaml
```

> Note: `--dry-run` values can be `none`, `server`, or `client`. If `client` strategy, only print the object that would be sent, without sending it. If `server` strategy, submit server-side request without persisting the resource.

---

Delete all evicted pods: `kubectl get pods | grep Evicted | awk '{print $1}' | xargs kubectl delete pod`
