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
        <li><a href="#running-exporter-inside-truenas">Running exporter inside truenas</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li>
      <a href="#exposed-metrics">Exposed metrics</a>
      <ul>
        <li><a href="#common-labels">Common labels</a></li>
        <li><a href="#memory">Memory</a></li>
        <li><a href="#disks">Disks</a></li>
        <li><a href="#network-interfaces">Network interfaces</a></li>
        <li><a href="#cpu">CPU</a></li>
        <li><a href="#processes">Processes</a></li>
        <li><a href="#uptime">Uptime + NTP</a></li>
        <li><a href="#system-load">System Load</a></li>
        <li><a href="#nfs">NFS</a></li>
        <li><a href="#zfs">ZFS</a></li>
      </ul>
    </li>
    <li><a href="#dashboards">Dashboards</a></li>
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
    - [x] Fully detailed list of all metrics
    - [x] Multiple dashboards with pictures
- [x] Convert all metrics to prometheus metrics without catch all rules
- [x] Unify all metrics to a similar schema

See the [open issues]([https://github.com/github_username/repo_name](https://github.com/Supporterino/truenas-graphite-to-prometheus)/issues) for a full list of proposed features (and known issues).

<!-- Supported versions -->
## Supported Versions
Those are the supported and tested versions of TrueNAS in combination with this exporter.
|TrueNAS Version|Supported|Tested|
|---------------|---------|------|
|23.10.0|:grey_question: (should work)|:x:|
|23.10.1|:white_check_mark:|:white_check_mark:|
|23.10.2|:white_check_mark:|:white_check_mark:|
|24.04|:white_check_mark:|:white_check_mark:|


<!-- GETTING STARTED -->
## Getting Started

### TrueNAS Scale

TrueNAS SCALE has its own ability to export reporting data to other apps or charts in the Graphite protocol (e.g. Netdata, Prometheus/Grafana). 

To create or edit the reporter for use with Prometheus:
1. Go to the `Reporting` tab and click the `Exporters` button on the top right.
2. Click `Add` to create a new reporter or click the `Edit` pencil icon next to the reporter you wish to use.

![Screenshot 2023-12-20 at 22 38 49](https://github.com/Supporterino/truenas-graphite-to-prometheus/assets/25184990/228eec2b-e612-4772-8bde-440ac3bcaef4)

Ensure the following fields are adjusted depending on your target app or chart, as outlined in the [TrueNAS instructions](https://www.truenas.com/docs/scale/scaleuireference/reportingscreensscale/).

* The prefix for the graphite metrics need to be set to `truenas` for the mapping file to work
* The hostname field should be choosen according to your needs it will later populate the `instance` label of your metrics
* The `update every` field should match your scrape time
* For `Send Names Instead Of Ids`, leave it blank and it will default to `true` (otherwise it may error out when trying to create the exporter).
 
![Screenshot 2023-12-20 at 22 40 14](https://github.com/Supporterino/truenas-graphite-to-prometheus/assets/25184990/5a6cfd79-42ae-4173-bee5-42bb1d43d7b9)

The destination ip and port need to be set to target your `graphite_exporter` I won't cover the setup process of this tool since it was already present for me. Feel free to open a PR with an recommended install method.

### graphite_exporter

You obviously need a running `graphite_exporter` which is scrabed by your prometheus instance and is reachable by your TrueNAS instance to push metrics to.

### Running exporter inside truenas

Check [TRUENAS.md](TRUENAS.md) to see options to use this exporter directly inside of TrueNAS.

<!-- USAGE EXAMPLES -->
## Usage

To utilise the provided `graphite_mapping.conf` replace your existing conf of your `graphite_exporter` and restart it. For the grafana dashboards you can simply import the provided `json` file.

<!-- EXPOSED METRICS -->
## Exposed metrics

See [METRICS.md](METRICS.md) for the exposed metrics by this config.

<!-- DASHBOARDS -->
## Dashboards

The dasboards are located inside the `dashboards` folder and are simple json files which can be imported into grafana und used with the metrics.

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
