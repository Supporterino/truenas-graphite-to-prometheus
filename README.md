<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#truenas-scale">TrueNAS Scale</a></li>
        <li><a href="#graphite_exporter">graphite_exporter</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li>
      <a href="#exposed-metrics">Exposed metrics</a>
      <ul>
        <li><a href="#common-labels">Common labels</a></li>
        <li><a href="#memory">Memory</a></li>
      </ul>
    </li>
    <li><a href="#contributing">Contributing</a></li>
  </ol>
</details>

# About The Project

The goal was to get the metrics from the TrueNAS reporting tap inside my normal monitoring stack which consists of prometheus and grafana. In earlier versions of TrueNAS this was possible by utilising the `collectd` graphite push service to push the metrics to a `graphite_exporter` instance which then converts the metrics to prometheus metrics based on the provided mapping file. In TrueNAS scale 23.10 the reporting system was changed to `netdata` and was missing the export feature all along. In `23.10.1` the export mechanism was added back in still lacking the ability to directly export the metrics to promeheus but still in the graphite form. But the metrics format changed due to the tool change.

The goal of this small repository is to provide you with a new `graphite_mapping.conf` which is suitable to be used with the new metrics exposed by TrueNAS. This mapping file is in active development and may change regularly in the near future. Besides the raw mapping file a based grafana dashboard nad a quick summary of the required settings in TrueNAS are also included.

### Built With

* [graphite_exporter](https://github.com/prometheus/graphite_exporter)
* [grafana](https://github.com/grafana/grafana)
* [TrueNAS Scale 23.10](https://www.truenas.com/truenas-scale/)

<!-- ROADMAP -->
## Roadmap

- [x] Prepare environment
- [x] Getting basic metrics extraction working
- [x] Documentation
    - [x] Start of git project
    - [ ] Fully detailed list of all metrics
    - [ ] Multiple dashboards with pictures
- [ ] Convert all metrics to prometheus metrics without catch all rules
- [ ] Unify all metrics to a similar schema

See the [open issues]([https://github.com/github_username/repo_name](https://github.com/Supporterino/truenas-graphite-to-prometheus)/issues) for a full list of proposed features (and known issues).

<!-- GETTING STARTED -->
## Getting Started

### TrueNAS Scale

Inside of TrueNAS you have to open the `Reporting` tab and then click the `Exporters` button to adjust the already present graphite exporter by hitting the edit icon.
![Screenshot 2023-12-20 at 22 38 49](https://github.com/Supporterino/truenas-graphite-to-prometheus/assets/25184990/228eec2b-e612-4772-8bde-440ac3bcaef4)
Once in the edit view you have to adjust three fields to match your later desired metrics.
* The prefix for the graphite metrics need to be set to `truenas` for the mapping file to work
* The hostname field should be choosen according to your needs it will later populate the `instance` label of your metrics
* The update every field should match your scrape time

![Screenshot 2023-12-20 at 22 40 14](https://github.com/Supporterino/truenas-graphite-to-prometheus/assets/25184990/5a6cfd79-42ae-4173-bee5-42bb1d43d7b9)

The destination ip and port need to be set to target your `graphite_exporter` I won't cover the setup process of this tool since it was already present for me. Feel free to open a PR with an recommended install method.

### graphite_exporter

You obviously need a running `graphite_exporter` which is scrabed by your prometheus instance and is reachable by your TrueNAS instance to push metrics to.

<!-- USAGE EXAMPLES -->
## Usage

To utilise the provided `graphite_mapping.conf` replace your existing conf of your `graphite_exporter` and restart it. For the grafana dashboards you can simply import the provided `json` file.

<!-- EXPOSED METRICS -->
## Exposed metrics

The graphite metrics are getting transformed into the following prometheus metrics. The metrics are grouped by their source and each metrics is explained with their labels and usecase.

### Common labels

All metrics share a pair of common labels. The first label is the `job` label which is set to `truenas` for each metric to identify the metrics from TrueNAS. The second label is the `instance` label. The value of the is directly related to the `hostname` field from the [Getting Started](#getting-started) section and can be used to identify the host from which the metrics come. This is useful once you have multiple TrueNAS instances.

### Memory

Both memeory statistics from TrueNAS are exported on the onside the physical memory statistics and the in depth memory statistics which translates to the following metrics.

|Metric name|Labels|Unit|Description|
|-----------|------|----|-----------|
|`physical_memory`|`kind` defines the memory type like free, used, etc...|`MiB`|The `physical_memory` metric shows the basic usage of the actual physical memory.|
|`swap`|`kind` defines the type of free or used|`MiB`|Shows the statistic about the swap. The free value shows the actual reserved swap of the system.|
|`memory_kernel`|`kind` the resource of the kernel|`MiB`|Break down of the memory internals of the kernel. More information [here](https://blog.netdata.cloud/unlock-the-secrets-of-kernel-memory-usage/)|
|`memory_available`||`MiB`|The amount of memory available to the whole system|
|`memory_comitted`||`MiB`|Comitted memory|
|`memory_slab`|`kind` describes the type of slab memory|`MiB`|Detailed metrics about the kernel slab memory in respect of claimability.|
|`memory_transparent_hugepages`|`kind` owner of the hugepage|`MiB`|The size of the hugepages in respect of their owner via the `kind` label.|
|`memory_writeback`|`kind` type of writeback operation|`MiB`|Size of the idividual writeback memory types.|

### Disks

|Metric name|Labels|Unit|Description|
|-----------|------|----|-----------|
|`disk_io`|<ul><li>`disk` name of the disk</li><li>`op` type of operation</li></ul>|`KiB`|The I/O operations of an individual disk devided by the kind of operation.|
|`disk_io_ops`|<ul><li>`disk` name of the disk</li><li>`op` type of operation</li></ul>|`ops/sec`|The amount of I/O operations per disk and operation type.|
|`disk_io_backlog`|`disk` name of the disk|`ms`|Shows the time an operation remains in the backlog of the disk and awaits the execution.|
|`disk_busy`|`disk` name of the disk|`ms`|The amount of time the disk was busy with I/O operations.|
|`disk_utilization`|`disk` name of the disk|`percent`|Percent of time the disk was busy doing any operation. Modern SSDs can do multiple operations in parallel so a high value ins't necesarly a warning.|
|`disk_iotime`|<ul><li>`disk` name of the disk</li><li>`op` type of operation</li></ul>|`ms/s`|The sum of the duration of all completed I/O operations.|
|`disk_qops`|`disk` name of the disk|`ops`|The number of currently active operations on the disk.|
|`disk_await`|<ul><li>`disk` name of the disk</li><li>`op` type of operation</li></ul>|`ms/ops`|The average time an operations needs to be completed. Includes queue time and execution time.|
|`disk_io_size`|<ul><li>`disk` name of the disk</li><li>`op` type of operation</li></ul>|`KiB/ops`|The average size of an I/O operation by operation type.|
|`system_io`|`op` type of operation|`KiB/s`|The total in and out traffic of the TrueNAS system.|

### Network interfaces

|Metric name|Labels|Unit|Description|
|-----------|------|----|-----------|
|`interface_io`|<ul><li>`interface` name of the interface</li><li>`op` type of operation</li></ul>|`kilobits/s`|The I/O operations of an individual interface devided by the kind of operation.|
|`interface_speed`|`interface` name of the interface|`kilobits/s`|The maximum speed of an interface.|
|`interface_duplex`|<ul><li>`interface` name of the interface</li><li>`state` type of duplex</li></ul>|`boolean`|Indicates which duplex state an interface is active in.|
|`interface_operationstate`|<ul><li>`interface` name of the interface</li><li>`state` type of operationstate</li></ul>|`boolean`|Indicates in which operation state an interface is.|
|`interface_carrierstate`|<ul><li>`interface` name of the interface</li><li>`state` type of carrierstate</li></ul>|`boolean`|Indicates in which carrier state an interface is.|
|`interface_mtu`|`interface` name of the interface|`octets`|The mtu of the interface.|
|`interface_packets`|<ul><li>`interface` name of the interface</li><li>`op` type of operation</li></ul>|`packets/s`|Amount of packets per interface and type of operation.|
|`system_net_io`|`op` type of operation|`kilobits/s`|The total in and out traffic of the network of the TrueNAS system.|
|`interface_errors`|<ul><li>`interface` name of the interface</li><li>`op` direction of traffic</li></ul>|`erros/s`|Amount of packets erros per interface and direction of traffic.|
|`interface_drops`|<ul><li>`interface` name of the interface</li><li>`op` direction of traffic</li></ul>|`drops/s`|Amount of packets drops per interface and direction of traffic.|

### CPU

|Metric name|Labels|Unit|Description|
|-----------|------|----|-----------|
|`interrupts`|`kind` defines type of interrupt. `hard` = top half, `soft` = bottom half|`interrupts/s`|Number of interrupts in the total system.|
|`cpu_softirq`|`cpu` defines the core|`interrupts/s`|Number of softirq interrupts per core.|
|`context_switches`||`context switches/s`|The number of context switches of the whole system.|
|`cpu_total`|`kind` type of cpu usage|`percent`|Shows the total cpu consumption of the system by type.|
|`cpu_temperature`|`cpu` defines the core|`°C`|The temperature of each physical cpu core.|
|`cpu_throttling`|`cpu` defines the core|`events/s`|The number of events which get held back for processing by the core.|
|`cpu_frequency`|`cpu` defines the core|`MHz`|The speed of the cpu core.|
|`cpu_idlestate`|<ul><li>`cpu` defines the core</li><li>`state` the corresponding C-state</li></ul>|`percent`|The percent of time spent in the C-state.|
|`cpu_usage`|<ul><li>`cpu` defines the core</li><li>`kind` type of cpu usage</li></ul>|`percent`|Shows consumption per core and type.|

### Processes

|Metric name|Labels|Unit|Description|
|-----------|------|----|-----------|
|`processes_forks`||`processes/s`|Number of processes which get forked.|
|`processes`|`kind` type of process|`processes`|Number of processes in the appropriate states.|

### Uptime

|Metric name|Labels|Unit|Description|
|-----------|------|----|-----------|
|`uptime`||`seconds`|The uptime of the system.|
|`clock_synced`||`boolean`|Indicator if the system clock is synced against ntp.|
|`clock_status`|`state` type of error|`boolean`|Indicator what failed during the ntp sync.|
|`clock_offset`||`ms`|Offset of the local system clock compared to ntp server.|

### System Load

|Metric name|Labels|Unit|Description|
|-----------|------|----|-----------|
|`system_load`|`kind` type of load sampling (1,5,15)|`load`|The load of the complete system in linux load numbers.|

### NFS

|Metric name|Labels|Unit|Description|
|-----------|------|----|-----------|
|`nfs_readcache`|`op` type of operation on cache|`reads/s`|Defines the number of reads of each kind of operation on the nfs readcache.|
|`nfs_io`|`op` operation type|`kilobytes/s`|The load on the nfs server by each operation.|
|`nfs_threads`||`threads`|Number of threads the nfs server is using.|
|`nfs_net`|`op` type of network|`packets/s`|The number of packtes per protocol which get handeled by the nfs server.|
|`nfs_rpc`|`op` type of rpc|`calls/s`|Number of remote procedure calls on the server api.|
|`nfs_proc4`|`op` type of proc4 call|`calls/s`|The number of nfs v4 calls per second.|
|`nfs_proc4ops`|`op` operation of proc4|`ops/s`|The number of protocol 4 operations called by the server.|

### ZFS

|Metric name|Labels|Unit|Description|
|-----------|------|----|-----------|
|`zfs_arc_size`|`op` kind of target|`MiB`|Size of the different arc cache types.|
|`zfs_l2_size`|`op` kind of target|`MiB`|Size of the l2 cache objects.|
|`zfs_reads`|`op` target of the read command|`reads/s`|Number of reads on the diffrent parts of zfs.|
|`zfs_hits`|`op` hit or miss type|`percent`|Percentage for the type of cache hit.|
|`zfs_hits_rate`|`op` hit or miss type|`events/s`|Number of hits for the type of cache hit.|
|`zfs_dhits`|`op` hit or miss type|`percent`|Percentage for the type of cache hit.|
|`zfs_dhits_rate`|`op` hit or miss type|`events/s`|Number of hits for the type of cache hit.|
|`zfs_phits`|`op` hit or miss type|`percent`|Percentage for the type of cache hit.|
|`zfs_phits_rate`|`op` hit or miss type|`events/s`|Number of hits for the type of cache hit.|
|`zfs_mhits`|`op` hit or miss type|`percent`|Percentage for the type of cache hit.|
|`zfs_mhits_rate`|`op` hit or miss type|`events/s`|Number of hits for the type of cache hit.|
|`zfs_l2hits`|`op` hit or miss type|`percent`|Percentage for the type of cache hit.|
|`zfs_l2hits_rate`|`op` hit or miss type|`events/s`|Number of hits for the type of cache hit.|
|`zfs_list_hits`|`op` type of lists|`hits/s`|Number of hits per list per second.|
|`zfs_arc_size_breakdown`|`op` type of arc cache|`percent`|Percent for each type of arc of the total arc size.|
|`zfs_important_ops`|`op` type of operation|`ops/s`|Number of important zfs operations.|
|`zfs_actual_hits`|`op` hit or miss type|`percent`|Percentage for the type of cache hit.|
|`zfs_actual_hits_rate`|`op` hit or miss type|`events/s`|Number of hits for the type of cache hit.|
|`zfs_demand_data_hits`|`op` hit or miss type|`percent`|Percentage for the type of cache hit.|
|`zfs_demand_data_hits_rate`|`op` hit or miss type|`events/s`|Number of hits for the type of cache hit.|
|`zfs_prefetch_data_hits`|`op` hit or miss type|`percent`|Percentage for the type of cache hit.|
|`zfs_prefetch_data_hits_rate`|`op` hit or miss type|`events/s`|Number of hits for the type of cache hit.|
|`zfs_hash_elements`|`op` current, max|`elements`|Number of hash elements present and maximum.|
|`zfs_hash_chains`|`op` current, max|`chains`|Number of hash chains present and maximum.|
|`zfs_pool`|<ul><li>`pool` name of the pool</li><li>`state`</li></ul>|`boolean`|Shows the states of the pool with boolean indicating if they are active.|


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
