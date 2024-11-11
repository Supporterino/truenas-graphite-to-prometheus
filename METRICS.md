# Exposed metrics

The graphite metrics are getting transformed into the following prometheus metrics. The metrics are grouped by their source and each metrics is explained with their labels and usecase.

## Common labels

All metrics share a pair of common labels. The first label is the `job` label which is set to `truenas` for each metric to identify the metrics from TrueNAS. The second label is the `instance` label. The value of the is directly related to the `hostname` field from the [Getting Started](#getting-started) section and can be used to identify the host from which the metrics come. This is useful once you have multiple TrueNAS instances.

## Memory

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

## Disks

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
|`disk_temperature`|`serial` disk serial|`°C`|Temperature of each disk in celcius.|

## Network interfaces

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

## CPU

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

## Processes

|Metric name|Labels|Unit|Description|
|-----------|------|----|-----------|
|`processes_forks`||`processes/s`|Number of processes which get forked.|
|`processes`|`kind` type of process|`processes`|Number of processes in the appropriate states.|

## Uptime

|Metric name|Labels|Unit|Description|
|-----------|------|----|-----------|
|`uptime`||`seconds`|The uptime of the system.|
|`clock_synced`||`boolean`|Indicator if the system clock is synced against ntp.|
|`clock_status`|`state` type of error|`boolean`|Indicator what failed during the ntp sync.|
|`clock_offset`||`ms`|Offset of the local system clock compared to ntp server.|

## System Load

|Metric name|Labels|Unit|Description|
|-----------|------|----|-----------|
|`system_load`|`kind` type of load sampling (1,5,15)|`load`|The load of the complete system in linux load numbers.|

## NFS

|Metric name|Labels|Unit|Description|
|-----------|------|----|-----------|
|`nfs_readcache`|`op` type of operation on cache|`reads/s`|Defines the number of reads of each kind of operation on the nfs readcache.|
|`nfs_io`|`op` operation type|`kilobytes/s`|The load on the nfs server by each operation.|
|`nfs_threads`||`threads`|Number of threads the nfs server is using.|
|`nfs_net`|`op` type of network|`packets/s`|The number of packtes per protocol which get handeled by the nfs server.|
|`nfs_rpc`|`op` type of rpc|`calls/s`|Number of remote procedure calls on the server api.|
|`nfs_proc4`|`op` type of proc4 call|`calls/s`|The number of nfs v4 calls per second.|
|`nfs_proc4ops`|`op` operation of proc4|`ops/s`|The number of protocol 4 operations called by the server.|

## ZFS

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

## k3s

|Metric name|Labels|Unit|Description|
|-----------|------|----|-----------|
|`k3s_pod_cpu`|`pod` the pod name|`ns`|A number that represents the cpu usage of the pod. (cpu time in ns)|
|`k3s_pod_mem`|`pod` the pod name|`bytes`|The number of bytes of memory this pod is using.|
|`k3s_pod_net`|<ul><li>`pod` the pod name</li><li>`direction` the direction of network traffic</li></ul>|`bytes`|The number of bytes in/out of the pod over the network interface.|

## systemd services

|Metric name|Labels|Unit|Description|
|-----------|------|----|-----------|
|`services_cpu`|`service` name of systemd service|`percent`|Percent of cpu usage per service. 100% = 1 core|
|`services_iops`|<ul><li>`service` name of systemd service</li><li>`op` kind of operation</li></ul>|`ops/s`|Number of operations on I/O.|
|`services_io`|<ul><li>`service` name of systemd service</li><li>`op` kind of operation</li></ul>|`kilobits/s`|I/O amount per service.|
|`services_mem`|`service` name of systemd service|`MiB`|Memory usage per service.|