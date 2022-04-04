## Monitoring

Prometheus is part of the Cloud Native Computing Foundation (CNCF). As a Kubernetes plugin, it allows one to scrape resource usage metrics from Kubernetes objects across the entire cluster. It also has several client libraries which allow you to instrument your application code in order to collect application level metrics.

Collecting metrics is the first step, making use of the data collected is the next. We have the ability to expose lots of data points. Graphing the data with a tool like Grafana can allow for visual understanding of the cluster and application status.

---

## Logging

Logging, like monitoring, is a vast subject in IT. It has many tools that you can use as part of your arsenal.

Typically, logs are collected locally and aggregated before being ingested by a search engine and displayed via a dashboard which can use the search syntax. While there are many software stacks that you can use for logging, the Elasticsearch, Logstash, and Kibana Stack ([ELK](https://www.elastic.co/videos/introduction-to-the-elk-stack)) has become quite common.

In Kubernetes, the kubelet writes container logs to local files (via the Docker logging driver). The kubectl logs command allows you to retrieve these logs.

Cluster-wide, you can use Fluentd to aggregate logs. Setting up Fluentd for Kubernetes logging is a good exercise in understanding DaemonSets. Fluentd agents run on each node via a DaemonSet, they aggregate the logs, and feed them to an Elasticsearch instance prior to visualization in a Kibana dashboard.

As a distributed system, Kubernetes lacks monitoring and tracing tools which are cluster-aware. Other CNCF projects have started to handle various areas. As they are independent projects, you may find they have some overlap in capability, e.g.: Prometheus, Fluentd, OpenTracing and Jaeger.

### > System and Agent Logs

Where system and agent files are found depends on the existence of systemd. Those with systemd will log to journalctl, which can be viewed with `journalctl -a`. Unless the `/var/log/journal` directory exists, the journal is volatile. As Kubernetes can generate a lot of logs, it would be advisable to configure log rotation, should this directory be created.

Without systemd, the logs will be created under `/var/log/<agent>.log`, in which case it would also be advisable to configure log rotation.
