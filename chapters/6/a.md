## Accessing K8s APIs

To perform any action in a Kubernetes cluster, you need to access the API and go through three main steps:
- Authentication (Certificate or Webhook)
- Authorization (RBAC or Webhook)
- Admission Controls.

There are three main points to remember with authentication in Kubernetes:

- in its straightforward form, authentication is done with certificates, tokens or basic authentication (i.e. username and password)
- users are not created by the API, but should be managed by the operating system or an external server
- `system accounts` are used by processes to access the API.

There are two more advanced authentication mechanisms:
- webhooks which can be used to verify bearer tokens
- and connection with an external OpenID provider.

Once a request is authenticated, it needs to be authorized to be able to proceed through the Kubernetes system and perform its intended action.

There are three main authorization modes and two global **Deny/Allow** settings. The three main modes are:
- Node
- RBAC
- Webhook.

The Node authorization is dedicated for kubelet to communicate to the kube-apiserver such that it does not need to be allowed via **RBAC**. All non-kubelet traffic would then be checked via RBAC.

The authorization modes implement policies to allow requests. Attributes of the requests are checked against the policies (e.g. user, group, namespace, verb).

All resources are modeled as API objects in Kubernetes, from Pods to Namespaces. They also belong to **API Groups**, such as core and apps. These resources allow HTTP verbs such as POST, GET, PUT, and DELETE. RBAC settings are additive, with no permission allowed unless defined.

**Rules** are operations which can act upon an API group. **Roles** are one or more rules which affect, or have a scope of, a single namespace, whereas **ClusterRoles** have a scope of the entire cluster.

Each operation can act upon one of three subjects, which are **User** which relies on the operating system to manage, **Group** which also is managed by the operating system and **ServiceAccounts** which are intended to be assigned to pods and processes instead of people.

Roles can then be used to configure an association of apiGroups, resources, and the verbs allowed to them. The user can then be bound to a role limiting what and where they can work in the cluster.

`Admission controllers` are pieces of software that can access the content of the objects being created by the requests. They can modify the content or validate it, and potentially deny the request.
