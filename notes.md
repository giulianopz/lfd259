How to apply manifests right from the clipboard using a simple technique:

```
kubectl apply -f -
<ctrl> + v  // paste
<enter>     // flush
<ctrl> + d  // trigger EOF
```

But don't accidentally hit <ctrl> + d twice - it'll close your bash session

TIL: How to create Kubernetes manifests real quick 🤯

Use kubectl create --dry-run=client -o yaml

Example:

```
kubectl create deployment foo \
  --image=nginx:1.21 \
  --dry-run=client \
  -o yaml
```
