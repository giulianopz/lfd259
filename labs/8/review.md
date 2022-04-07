1. Find and use the troubleshoot-review1.yaml file to create a deployment. The create command will fail. Edit the file to fix issues such that a single pod runs for at least a minute without issue. There are several things to fix:
```
k create -f troubleshoot-review1.yaml
vi troubleshoot-review1.yaml
>apiVersion: apps/v1                            <<
>kind: Deployment
>metadata:
>  annotations:
>    deployment.kubernetes.io/revision: "1"
>  generation: 1
>  labels:
>    run: igottrouble
>  name: igottrouble
>spec:
>  replicas: 0
>  selector:
>    matchLabels:
>      run: igottrouble                         <<
>  strategy:
>    rollingUpdate:
>      maxSurge: 1
>      maxUnavailable: 1
>    type: RollingUpdate
>  template:
>    metadata:
>      creationTimestamp: null
>      labels:
>        run: igottrouble
>    spec:
>      containers:
>      - image: vish/stress
>        imagePullPolicy: Always
>        name: igottrouble
>        resources:
>          limits:
>            cpu: "1"
>            memory: "1Gi"
>          requests:
>            cpu: "0.5"                         <<
>            memory: "500Mi"
>        args:
>        - -cpus
>        - "2"
>        - -mem-total
>        - "1950Mi"
>        - -mem-alloc-size
>        - "100Mi"
>        - -mem-alloc-sleep
>        - "1s"
>        terminationMessagePath: /dev/termination-log
>        terminationMessagePolicy: File
>      dnsPolicy: ClusterFirst
>      restartPolicy: Always
>      schedulerName: default-scheduler
>      securityContext: {}
>      terminationGracePeriodSeconds: 30
```
When fixed it should look like this:
```
k get deploy igottrouble
NAME          READY   UP-TO-DATE   AVAILABLE   AGE
igottrouble   1/1     1            1           5m13s
```
