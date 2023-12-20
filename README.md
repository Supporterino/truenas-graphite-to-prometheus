# TrueNAS metrics in prometheus

The goal was to get the metrics from the TrueNAS reporting tap inside my normal monitoring stack which consists of prometheus and grafana. In earlier versions of TrueNAS this was possible by utilising the `collectd` graphite push service to push the metrics to a `graphite_exporter` instance which then converts the metrics to prometheus metrics based on the provided mapping file. In TrueNAS scale 23.10 the reporting system was changed to `netdata` and was missing the export feature all along. In `23.10.1` the export mechanism was added back in still lacking the ability to directly export the metrics to promeheus but still in the graphite form. But the metrics format changed due to the tool change.

The goal of this small repository is to provide you with a new `graphite_mapping.conf` which is suitable to be used with the new metrics exposed by TrueNAS. This mapping file is in active development and may change regularly in the near future. Besides the raw mapping file a based grafana dashboard nad a quick summary of the required settings in TrueNAS are also included.

## Requirements

### TrueNAS Scale

Inside of TrueNAS you have to open the `Reporting` tab and then click the `Exporters` button to adjust the already present graphite exporter by hitting the edit icon.
![Screenshot 2023-12-20 at 22 38 49](https://github.com/Supporterino/truenas-graphite-to-prometheus/assets/25184990/228eec2b-e612-4772-8bde-440ac3bcaef4)
Once in the edit view you have to adjust three fields to match your later desired metrics.
* The prefix for the graphite metrics need to be set to `truenas` for the mapping file to work
* The hostname field should be choosen according to your needs it will later populate the `instance` label of your metrics
* The update every field should match your scrape time
![Screenshot 2023-12-20 at 22 40 14](https://github.com/Supporterino/truenas-graphite-to-prometheus/assets/25184990/5a6cfd79-42ae-4173-bee5-42bb1d43d7b9)
