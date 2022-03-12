## Volumes

A Kubernetes volume shares at least the Pod lifetime, not the containers within. Should a container terminate, the data would continue to be available to the new container.

A **PersistentVolume** (PV) is a storage abstraction used to retain data longer than the Pod using it. Pods define a volume of type **PersistentVolumeClaim** (PVC) with various parameters for size and possibly the type of backend storage known as its StorageClass. The cluster then attaches the PersistentVolume.

There are two API Objects which exist to provide data to a Pod already. Encoded data can be passed using a **Secret** and non-encoded data can be passed with a **ConfigMap**.

A Pod specification can declare one or more volumes and where they are made available. Each requires a name, a type, and a mount point.

The same volume can be made available to multiple containers within a Pod, which can be a method of container-to-container communication.
To share a volumes between two pods, just declare in the spec two volume mounts pointing to the same volume name:
```
[...]
   containers:
   - name: alphacont
     image: busybox
     volumeMounts:
     - mountPath: /alphadir
       name: sharevol
   - name: betacont
     image: busybox
     volumeMounts:
     - mountPath: /betadir
       name: sharevol
   volumes:
   - name: sharevol
     emptyDir: {}
```

A volume can be made available to multiple Pods, with each given an access mode to write. There is no concurrency checking, which means data corruption is probable, unless outside locking takes place.

A particular access mode is part of a Pod request:
- **RWO** (ReadWriteOnce), which allows read-write by a single node
- **ROX** (ReadOnlyMany), which allows read-only by multiple nodes
- **RWX** (ReadWriteMany), which allows read-write by many nodes.

A volume is a directory, possibly pre-populated, made available to containers in a Pod. The creation of the directory, the backend storage of the data and the contents depend on the volume type. As of v1.14, there are 28 different volume types, each having particular configuration options and dependencies.

One of the many types of storage available is an **emptyDir**. The kubelet will create the directory in the container, but not mount any storage. Any data created is written to the shared container space. As a result, it would not be persistent storage.

There are several types that you can use to define volumes, each with their pros and cons:
- In GCE or AWS, you can use volumes of type *GCEpersistentDisk* or *awsElasticBlockStore*, which allows you to mount GCE and EBS disks in your Pods, assuming you have already set up accounts and privileges
- The *hostPath* volume mounts a resource from the host node filesystem. The resource could be a directory, file socket, character, or block device. These resources must already exist on the host to be used. There are two types, *DirectoryOrCreate* and *FileOrCreate*, which create the resources on the host, and use them if they don't already exist
- *NFS* (Network File System) and *iSCSI* (Internet Small Computer System Interface) are straightforward choices for multiple readers scenarios
- *rbd* for block storage or CephFS and GlusterFS, if available in your Kubernetes cluster, can be a good choice for multiple writer needs.

Phases to persistent storage:
- **Provisioning**, can be from PVs created in advance by the cluster administrator, or requested from a dynamic source, such as the cloud provider
- **Binding**, when a control loop on the master notices the PVC and locates a matching PV or waits for the StorageClass provisioner to create one
- **Using**, when the bound volume is mounted for the Pod to use,
- **Releasing**, when the Pod is done with the volume and an API request is sent, deleting the PVC; the resident data remains depending on the `persistentVolumeReclaimPolicy`
- **Reclaiming**, has three options:
  - `Retain`, which keeps the data intact, allowing for an administrator to handle the storage and data
  - `Delete` tells the volume plugin to delete the API object, as well as the storage behind it
  - The `Recycle` option runs an `rm -rf /mountpoint` and then makes it available to a new claim; with the stability of dynamic provisioning, the Recycle option is planned to be deprecated.

Persistent volumes are cluster-scoped, but persistent volume claims are namespace-scoped.


With a persistent volume created in your cluster, you can then write a manifest for a claim and use that claim in your pod definition. In the Pod, the volume uses the PersistentVolumeClaim:
```
[...]
spec:
    containers:
[...]
    volumes:
        - name: test-volume
          persistentVolumeClaim:
                claimName: myclaim
```

---

While handling volumes with a persistent volume definition and abstracting the storage provider using a claim is powerful, a cluster administrator still needs to create those volumes in the first place. Starting with Kubernetes v1.4, Dynamic Provisioning allowed for the cluster to request storage from an exterior, pre-configured source. API calls made by the appropriate plugin allow for a wide range of dynamic storage use.


The **StorageClass** API resource allows an administrator to define a persistent volume provisioner of a certain type, passing storage-specific parameters.

With a StorageClass created, a user can request a claim, which the API Server fills via auto-provisioning. The resource will also be reclaimed as configured by the provider. **AWS** and **GCE** are common choices for dynamic storage, but other options exist, such as a **Ceph** cluster or **iSCSI**. Single, default class is possible via annotation.

There are also providers you can create inside of you cluster, which use Custom Resource Definitions and local operators to manage storage:
- Rook
- Longhorn
