1. Create a new pod called `webone`, running the nginx service. Expose port 80:
```
k run webone --image=nginx --port=80 --restart=Never
```
2. Create a new service named webone-svc. The service should be accessible from outside the cluster:
```
k create service nodeport webone-svc --tcp=80:80
```

1. Update both the pod and the service with selectors so that traffic to the service IP shows the web server content:
```
k label pods webone app=review
k patch service webone-svc -p '{"spec":{"selector":{"app":"review"}}}'
```

4. Change the type of the service such that it is only accessible from within the cluster. Test that exterior access no longer works, but access from within the node works:
```
k patch service webone-svc -p '{"spec":{"type":"ClusterIP"}}'
```

5. Deploy another pod, called `webtwo`, this time running the `wlniao/website` image. Create another service, called `webtwo-svc` such that only requests from within the cluster work. Note the default page for each server is distinct:
```
k run webtwo --image=wlniao/website
k create svc clusterip webtwo-svc --tcp=80
```

6. Install and configure an ingress controller such that requests for `webone.com` see the nginx default page, and requests for `webtwo.org `see the wlniao/website default page:
```
vi web-ingress.yaml
#apiVersion: networking.k8s.io/v1
#kind: Ingress
#metadata:
#  name: review-ingress
#spec:
#  ingressClassName: nginx
#  rules:
#  - host: webone.com
#    http:
#      paths:
#      - path: /
#        pathType: ImplementationSpecific
#        backend:
#          service:
#            name: webone-svc
#            port:
#              number: 80
#  - host: webtwo.org
#    http:
#      paths:
#      - backend:
#          service:
#            name: webtwo-svc
#            port:
#              number: 80
#        path: /
#        pathType: ImplementationSpecific
k create -f web-ingress.yaml
curl -H "Host: webone.com" 10.152.183.219
curl -H "Host: webtwo.org" 10.152.183.219
```
