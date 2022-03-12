## Deployment

With the ReplicaSets of a Deployment being kept, you can also roll back to a previous revision by using the `--record` option of the kubectl command, which allows annotation in the resource definition:
```
$ kubectl set image deploy mydeploy myapp=myapp:2.9 --record
deployment.apps/mydeploy image updated

$ kubectl get deployments mydeploy -o yaml
metadata:
    annotations:
            deployment.kubernetes.io/revision: "1"
            kubernetes.io/change-cause: kubectl set image deploy myapp=myapp:2.9 --record=true

$ kubectl set image deployment/mydeploy myapp=myapp:3.0
deployment.apps/mydeploy image updated

$ kubectl rollout history deployment/mydeploy
deployment.apps/mydeploy
REVISION     CHANGE-CAUSE
1            <none>
2            kubectl set image deploy myapp=myapp:2.9 --record=true

$ kubectl get pods
NAME                       READY    STATUS               RESTARTS    AGE
mydeploy-2141819201-tcths  0/1      ImagePullBackOff     0           1m​
```

Should an update fail, due to an improper image version, for example, you can roll back the change to a working version with:
```
$ kubectl rollout undo deployment/mydeploy
deployment.apps/mydeploy rolled back

$ kubectl get pods
NAME                       READY STATUS  RESTARTS AGE
mydeploy-33781556678-eq5i6 1/1   Running 0        7s
```

You can roll back to a specific revision with:
```
$ kubectl rollout undo deployment/mydeploy --to-revision=2
```

One can also pause a Deployment, and then resume it:
```
$ kubectl rollout pause deployment/mydeploy
deployment.apps/test2 paused

$ kubectl rollout resume deployment/mydeploy
deployment.apps/test2 paused
```

> Note: The `create` generator does not have a record function.

> Note: The `--record` option has been deprecated and will be removed soon. At the moment, there isn't a suggested replacement, but you could add your own annotations to track the intended changes.
