## Troubleshooting

Kubernetes relies on API calls and is sensitive to network issues. Standard Linux tools and processes are the best method for troubleshooting your cluster. If a shell, such as bash, is not available in an affected Pod, consider deploying another similar pod with a shell, like busybox. DNS configuration files and tools like dig are a good place to start. For more difficult challenges, you may need to install other tools, like `tcpdump`.

Large and diverse workloads can be difficult to track, so monitoring of usage is essential. Monitoring is about collecting key metrics, such as CPU, memory, and disk usage, and network bandwidth on your nodes, as well as monitoring key metrics in your applications. These features have not been ingested into Kubernetes, so exterior tools will be necessary, such as `Prometheus`. Prometheus provides a time-series database, as well as integration with `Grafana` for visualization and dashboards.

Logging activity across all the nodes is another feature not part of Kubernetes. Using `Fluentd` can be a useful data collector for a unified logging layer. Having aggregated logs can help visualize the issues, and provides the ability to search all logs.

The issues found with a decoupled system like Kubernetes are similar to those of a traditional datacenter, plus the added layers of Kubernetes controllers:

- Errors from the command line
- Pod logs and state of Pods
- Use shell to troubleshoot Pod DNS and network
- Check node logs for errors, make sure there are enough resources allocated
- RBAC, SELinux or AppArmor for security settings​
- API calls to and from controllers to kube-apiserver
- Inter-node network issues, DNS and firewall
- Control plane controllers (control Pods in pending or error state, errors in log files, sufficient resources, etc).
