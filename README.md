> [!WARNING]
> Going forward from exporter configuration version 2.1, you must also use the Netdata configuration included in the repository to restore the pre‑25.04 metrics. Instructions are provided below. This action is taken since TrueNAS 25.04 dropped a lot of default metrics which doesn't make sense for me.

# About The Project

The goal was to get the metrics from the TrueNAS reporting tap inside my normal monitoring stack which consists of prometheus and grafana. In earlier versions of TrueNAS this was possible by utilising the `collectd` graphite push service to push the metrics to a `graphite_exporter` instance which then converts the metrics to prometheus metrics based on the provided mapping file. In TrueNAS scale 23.10 the reporting system was changed to `netdata` and was missing the export feature all along. In `23.10.1` the export mechanism was added back in still lacking the ability to directly export the metrics to promeheus but still in the graphite form. But the metrics format changed due to the tool change.

The goal of this small repository is to provide you with a new `graphite_mapping.conf` which is suitable to be used with the new metrics exposed by TrueNAS. This mapping file is in active development and may change regularly in the near future. Besides the raw mapping file a based grafana dashboard nad a quick summary of the required settings in TrueNAS are also included.

### Built With

* [graphite_exporter](https://github.com/prometheus/graphite_exporter)
* [grafana](https://github.com/grafana/grafana)
* [TrueNAS Scale 25.04](https://www.truenas.com/truenas-scale/)

## Roadmap

- [ ] Update dashboards
- [ ] Update metrics documentation -> move to unit label
- [ ] Persist the custom `netdata.conf` across TrueNAS Updates

See the [open issues](https://github.com/Supporterino/truenas-graphite-to-prometheus/issues) for a full list of proposed features (and known issues).

## Supported Versions
Those are the supported and tested versions of TrueNAS in combination with this exporter. Feel free to create a PR with a tested flag if you use a version not mentioned here.
|TrueNAS Version|Supported|Exporter Version|Tested|
|---------------|---------|----------------|------|
|23.10.x|:white_check_mark:|`v1.x.x`|:white_check_mark: by [@Supporterino](https://www.github.com/Supporterino)|
|24.04.x|:white_check_mark:|`v1.x.x`|:white_check_mark: by [@Supporterino](https://www.github.com/Supporterino)|
|24.10.x|:white_check_mark:|`v1.x.x`|:white_check_mark: by [@Supporterino](https://www.github.com/Supporterino)|
|25.04.x|:white_check_mark:|`v2.x.x`|:white_check_mark: by [@Supporterino](https://www.github.com/Supporterino)|

## Getting Started

### TrueNAS Scale

TrueNAS SCALE can export reporting data using the Graphite protocol. Below is a clear, copyable guide to creating or editing a graphite_reporter for Prometheus, plus an important Netdata configuration note and example commands.

Creating or editing a reporter in TrueNAS SCALE

1. Go to the `Reporting` tab and click the `Exporters` button on the top right.
2. Click `Add` to create a new reporter or click the `Edit` pencil icon next to the reporter you wish to use.

![Screenshot 2023-12-20 at 22 38 49](https://github.com/Supporterino/truenas-graphite-to-prometheus/assets/25184990/228eec2b-e612-4772-8bde-440ac3bcaef4)

Ensure the following fields are adjusted depending on your target app or chart, as outlined in the [TrueNAS instructions](https://www.truenas.com/docs/scale/scaleuireference/reportingscreensscale/).

* The prefix for the graphite metrics need to be set to `truenas` for the mapping file to work
* The hostname field should be choosen according to your needs it will later populate the `instance` label of your metrics
* The `update every` field should match your scrape time
* For `Send Names Instead Of Ids`, leave it blank and it will default to `true` (otherwise it may error out when trying to create the exporter).
* Destination IP and Port pointing to the host and port where your `graphite_exporter` is listening.
  
![Screenshot 2023-12-20 at 22 40 14](https://github.com/Supporterino/truenas-graphite-to-prometheus/assets/25184990/5a6cfd79-42ae-4173-bee5-42bb1d43d7b9)

> [!Note]
> You must copy the provided `netdata.conf` from this repository to your TrueNAS host at `/etc/netdata/netdata.conf` so Netdata uses the configuration we provide.

Example commands (run on the TrueNAS host or with appropriate privileges):
```bash
# Adjust the source path below to where you cloned/downloaded the repo
sudo cp /path/to/repo/netdata.conf /etc/netdata/netdata.conf
sudo chown root:root /etc/netdata/netdata.conf
# Restart Netdata to pick up the new config (service name may vary)
sudo systemctl restart netdata
```

> [!Important]
> TrueNAS updates replaces `/etc/netdata/netdata.conf`. You must re-copy/overwrite `/etc/netdata/netdata.conf` from this repository after each TrueNAS update until a permanent fix is available. I am working on a fix to make this persistent — in the meantime, reapply the config after updates.

Optional: reapply script
You can use a small script to reapply the config quickly:
```bash
#!/usr/bin/env bash
REPO_CONF="/path/to/repo/netdata.conf"
TARGET_CONF="/etc/netdata/netdata.conf"

if [ ! -f "$REPO_CONF" ]; then
  echo "Source config not found: $REPO_CONF"
  exit 1
fi

sudo cp "$REPO_CONF" "$TARGET_CONF"
sudo chown root:root "$TARGET_CONF"
sudo systemctl restart netdata
echo "netdata.conf applied and netdata restarted"
```
Make the script executable (e.g. `chmod +x apply-netdata-conf.sh`) and run it after TrueNAS updates.

### graphite_exporter

You obviously need a running `graphite_exporter` which is scrabed by your prometheus instance and is reachable by your TrueNAS instance to push metrics to.

### Running exporter inside truenas

Check [TRUENAS.md](TRUENAS.md) to see options to use this exporter directly inside of TrueNAS.

## Usage

To utilise the provided `graphite_mapping.conf` replace your existing conf of your `graphite_exporter` and restart it. For the grafana dashboards you can simply import the provided `json` file.

## Exposed metrics

> [!WARNING]
> Outdated will be updated soon

See [METRICS.md](METRICS.md) for the exposed metrics by this config.

## Dashboards

The dasboards are located inside the `dashboards` folder and are simple json files which can be imported into grafana und used with the metrics.

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
