## Deployment

With the ReplicaSets of a Deployment being kept, you can also roll back to a previous revision by using the `--record` option of the kubectl command, which allows you to record current command in the annotations of the resources being created or updated:
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
```

You can check and compare the ouput of specific revisions:
```
kubectl rollout history deployment try1 --revision=1 > one.out
kubectl rollout history deployment try1 --revision=2 > two.out
diff one.out two.out
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

## Strategies

Multiple deployment strategies are available:

- **recreate**: terminate the old version and release the new one
- **rolling update**: release a new version replacing one instance at a time.
- **blue/green**: release a new version alongside the old version then switch traffic
- **canary**: release a new version to a subset of users, then proceed to a full rollout
- **A/B testing**: release a new version to a subset of users in a precise way (HTTP headers, cookie, weight, etc.).

No all the strategies come out of the box: for more advanced options, the Kubernetes primitives are not enough and it can be necessary to setup a more advanced infrastructure (e.g. ingress controller, proxy, service mesh).

A deployment defined with a strategy of type `Recreate` will terminate all the running instances then recreate them with the newer version:
```
spec:
  replicas: 3
  strategy:
    type: Recreate
```

In a `RollingUpdate`, a secondary ReplicaSet is created with the new version of the application, then the number of replicas of the old version is decreased and the new version is increased until the correct number of replicas is reached:
```
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 2        # how many pods we can add at a time
      maxUnavailable: 0  # maxUnavailable define how many pods can be unavailable during the rolling update
```

In a `blue/green` deployment the *green* version of the application is deployed alongside the *blue* version. After testing that the new version meets the requirements, we update the Service that acts as a load balancer to send traffic only to the new version by replacing the version label in the `selector` field:
```
apiVersion: v1
kind: Service
metadata:
 name: my-app
 labels:
   app: my-app
spec:
 type: NodePort
 ports:
 - name: http
   port: 8080
   targetPort: 8080
 # Note here that we match both the app and the version.
 # When switching traffic, we update the label “version” with the appropriate value, i.e.: v2.0.0
 selector:
   app: my-app
   version: v1.0.0
```

A **canary** deployment consists of routing a subset of users to a new release: it can be achieved using two Deployments with common pod labels. One replica of the new version is released alongside the old version. Then after some time and if no error is detected, scale up the number of replicas of the new version and delete the old deployment.

You can use two ReplicaSets side by side, version A with three replicas (75% of the traffic), version B with one replica (25% of the traffic):

Excerpt from manifest of version A:
```
spec:
  replicas: 3
```

Excerpt from manifest of version B:
```
spec:
  replicas: 1
```

Using this ReplicaSet technique requires spinning-up as many pods as necessary to get the right percentage of traffic. This can be quite cumbersome to manage so if you are looking for a better managed traffic distribution, you have to look at load balancers such as **HAProxy** or service meshes like **Linkerd**, which provide greater controls over traffic.

A/B testing is actually a technique for making business decisions based on statistics, rather than a deployment strategy. It can be implemented using a canary deployment.

In addition to distributing traffic amongst versions based on weight, you can precisely target a given pool of users based on a few parameters (cookie, user agent, etc.).

**Istio**, like other service meshes, provides a finer-grained way to subdivide service instances with dynamic request routing based on weights and/or HTTP headers:
```
route:
- tags:
  version: v1.0.0
  weight: 90
- tags:
  version: v2.0.0
  weight: 10
```

Some code examples of the mentioned strategies can be found in this [repo](https://github.com/ContainerSolutions/k8s-deployment-strategies).

---

References:

- [Kubernetes deployment strategies](https://blog.container-solutions.com/kubernetes-deployment-strategies)
