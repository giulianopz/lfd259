## Secrets

Pods can access local data using volumes, but there is some data you don't want readable to the naked eye. Using the Secret API resource, such data can be base64-encoded:
```
# You can create, get, or delete secrets:
$ kubectl get secrets
# Secrets can be manually encoded with kubectl create secret:
$ kubectl create secret generic --help
$ kubectl create secret generic mysql --from-literal=password=root
```
You can see the encoded string inside the secret with kubectl. The secret will be decoded and be presented as a string saved to a file.

In order to encrypt secrets, you must create an **EncryptionConfiguration** object with a key and proper identity. Then, the kube-apiserver needs the `--encryption-provider-config` flag set to a previously configured provider, such as **aescbc** or **ksm**. Once this is enabled, you need to recreate every secret, as they are encrypted upon write.

> Warn: Prior to Kubernetes v1.18 secrets (and configMaps) were automatically updated. This could lead to issues. If a configuration was updated and a Pod restarted,​​​​​​​ it may be configured differently than other replicas. In newer versions these objects can be made immutable.

A secret can be used as an environmental variable in a Pod:
```
spec:
    containers:
    - image: mysql:5.5
      name: mysql
      env:
      - name: MYSQL_ROOT_PASSWORD
        valueFrom:
          secretKeyRef:
            name: mysql
            key: password
```

They are stored in the tmpfs storage on the host node, and are only sent to the host running Pod. All volumes requested by a Pod must be mounted before the containers within the Pod are started. So, a secret must exist prior to being requested.

You can also mount secrets as files using a volume definition in a Pod manifest. The mount path will contain a file whose name will be the key of the secret.
