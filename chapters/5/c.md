## ConfigMap

A similar API resource to Secrets is the **ConfigMap**, except the data is not encoded. In keeping with the concept of decoupling in Kubernetes, using a ConfigMap decouples a container image from configuration artifacts.

Like secrets, you can use ConfigMaps as environment variables or using a volume mount. They must exist prior to being used by a Pod, unless marked as optional. They also reside in a specific namespace.

In the case of environment variables, your Pod manifest will use the valueFrom key and the configMapKeyRef value to read the values. For instance:
```
env:
- name: SPECIAL_LEVEL_KEY
  valueFrom:
    configMapKeyRef:
      name: special-config
      key: special.how
```

With volumes, you define a volume with the configMap type in your pod and mount it where it needs to be used.
```
volumes:
  - name: config-volume
    configMap:
      name: special-config
```
