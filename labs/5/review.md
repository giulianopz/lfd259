1. Create a new secret called `specialofday` using the key `entree` and the value `meatloaf`:
    ```
    k create secret generic specialofday --from-literal entree=meatloaf
    ```

2. Create a new deployment called `foodie` running the nginx image:
    ```
    k create deployment foodie --image=nginx --dry-run=client -o yaml > foodie.yaml
    k create -f foodie.yaml
    ```

3. Add the `specialofday` secret to pod mounted as a volume under the `/food/` directory:
    ```
    k edit deployments.apps foodie
    #apiVersion: apps/v1
    #kind: Deployment
    #spec:
    #    spec:
    #    containers:
    #    - image: nginx
    #        imagePullPolicy: Always
    #        name: nginx
    #        volumeMounts:                         #<--- volume mount
    #        - mountPath: /food
    #        name: secret-vol                      #--->
    #    dnsPolicy: ClusterFirst
    #    restartPolicy: Always
    #    schedulerName: default-scheduler
    #    securityContext: {}
    #    terminationGracePeriodSeconds: 30
    #    volumes:                                  #<--- volume
    #    - name: secret-vol
    #        secret:
    #        secretName: specialofday              #--->
    ```

4. Execute a bash shell inside a foodie pod and verify the secret has been properly mounted:
    ```
    k exec -it foodie-8668587d55-knxnx -- ls /food
    ```

5. Update the deployment to use the `nginx:1.12.1-alpine` image and verify the new image is in use:
    ```
    k edit deployments.apps foodie
    #Change the image definition:
    #      - image: nginx:1.12.1-alpine
    k get deployments.apps foodie | gre -i image
    ```

6. Roll back the deployment and verify the typical, current stable version of nginx is in use again:
    ```
    k rollout history deployment foodie
    k rollout undo deployment foodie
    k get deployments.apps foodie | gre -i image
    ```
7. Create a new 200M NFS volume called `reviewvol` using the NFS server configured earlier in the lab:
    ```
    vi pvc.yaml
    #apiVersion: v1
    #kind: PersistentVolume
    #metadata:
    #    name: reviewvol
    #spec:
    #    storageClassName: review
    #    capacity:
    #        storage: 200M
    #    accessModes:
    #       - ReadWriteMany
    #    persistentVolumeReclaimPolicy: Retain
    #    nfs:
    #        path: /mnt                 #<-- Edit to match shared folder
    #        server: master             #<-- Edit to match cp node name or IP
    #        readOnly: false
    ```

8. Create a new PVC called `reviewpvc` which will uses the `reviewvol` volume:
    ```
    vi pvc.yaml
    #apiVersion: v1
    #kind: PersistentVolumeClaim
    #metadata:
    #    name: reviewpvc
    #spec:
    #    storageClassName: review
    #    accessModes:
    #       - ReadWriteMany
    #    resources:
    #        requests:
    #            storage: 200M
    ```

9.  Edit the deployment to use the PVC and mount the volume under `/newvol`:
    ```
    k edit deployments.apps foodie
    #[...]
    #spec:
    #  containers:
    #  - image: nginx
    #    imagePullPolicy: Always
    #    name: nginx
    #    resources: {}
    #    terminationMessagePath: /dev/termination-log
    #    terminationMessagePolicy: File
    #    volumeMounts:
    #    - mountPath: /food
    #      name: secret-vol
    #    - mountPath: /newvol
    #      name: reviewvol
    #[...]
    #volumes:
    #  - name: secret-vol
    #    secret:
    #      defaultMode: 420
    #      secretName: specialofday
    #  - name: reviewvol
    #    persistentVolumeClaim:
    #      claimName: reviewpvc
    #[...]
    ```

10. Execute a bash shell into the nginx container and verify the volume has been mounted:
    ```
    k exec -it foodie-58ff48bdb7-nz2n4 -- ls /newvol
    #hello.txt
    ```
11. Delete any resources created during this review:
    ```
    k delete pod foodie-58ff48bdb7-nz2n4
    k delete pvc reviewpvc
    k delete pv reviewvol
    ```
