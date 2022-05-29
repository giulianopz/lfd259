## Container Options

As Docker evolved, spreading their vendor-lock characteristics through the container creation and deployment life cycle, new projects and features have become popular. As other container engines become mature, Kubernetes continues to become more open and independent.

A **container runtime**[^1] is the component which runs the containerized application upon request. **Docker Engine** remains the default for Kubernetes, though **CRI-O** and others are gaining community support.

The containerized image is moving from Docker to one that is not bound to higher-level tools and that is more portable across operating systems and environments. The Open Container Initiative (**OCI**) was formed to help with this. Docker donated their **libcontainer** project to form a new codebase called [runC](https://github.com/opencontainers/runc) to support these goals.

Where Docker was once the only real choice for developers, the trend toward open specifications and flexibility indicates that building with vendor-neutral features is a wise choice[^2].

A developer looking toward the future would be wise to work with mostly open tools for containers and Kubernetes, but he or she should understand that Docker is still the production tool of choice outside of a Red Hat environment[^3] at the moment.

The goal of the Container Runtime Interface (**CRI**) is to allow easy integration of container runtimes with kubelet. By providing a protobuf method for API, specifications and libraries, new runtimes can easily be integrated without needing deep understanding of kubelet internals.

The project is in early stage, with lots of development in action. Now that **Docker-CRI** integration is done, new runtimes should be easily added and swapped out. At the moment, CRI-O, **rktlet** and **frakti** are listed as work-in-progress.

The **rkt** runtime, pronounced rocket, has gathered a lot of attention and it was expected to be the leading replacement for Docker until CRI-O became part of the official Kubernetes Incubator. CRI-O uses the Kubernetes Container Runtime Interface with OCI-compatible runtimes, thus its name.

The intent of the **containerd** project is not to build a user-facing tool instead, it is focused on exposing highly-decoupled low-level primitives: with a focus on supporting the low-level, or backend plumbing of containers, this project is better suited to integration and operation teams building specialized products, instead of typical build, ship, and run application.

[^1]: [A Comprehensive Container Runtime Comparison ](https://www.capitalone.com/tech/cloud/container-runtime/)

[^2]: [How Docker broke in half](https://www.infoworld.com/article/3632142/how-docker-broke-in-half.html)

[^3]: [RHEL 8 enables containers with the tools of software craftsmanship](https://www.redhat.com/en/blog/rhel-8-enables-containers-tools-software-craftsmanship-0)
