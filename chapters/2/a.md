## Container Options

As Docker evolved, spreading their vendor-lock characteristics through the container creation and deployment life cycle, new projects and features have become popular. As other container engines become mature, Kubernetes continues to become more open and independent.

A container runtime is the component which runs the containerized application upon request. Docker Engine remains the default for Kubernetes, though **CRI-O** and others are gaining community support.

The containerized image is moving from Docker to one that is not bound to higher-level tools and that is more portable across operating systems and environments. The Open Container Initiative (**OCI**) was formed to help with this. Docker donated their **libcontainer** project to form a new codebase called [runC](https://github.com/opencontainers/runc) to support these goals.

Where Docker was once the only real choice for developers, the trend toward open specifications and flexibility indicates that building with vendor-neutral features is a wise choice[^1].

A developer looking toward the future would be wise to work with mostly open tools for containers and Kubernetes, but he or she should understand that Docker is still the production tool of choice outside of a Red Hat environment[^2] at the moment.





[^1]: [How Docker broke in half](https://www.infoworld.com/article/3632142/how-docker-broke-in-half.html)

[^2]: [RHEL 8 enables containers with the tools of software craftsmanship](https://www.redhat.com/en/blog/rhel-8-enables-containers-tools-software-craftsmanship-0)
