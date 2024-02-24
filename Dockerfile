FROM prom/graphite-exporter:v0.15.0

COPY graphite_mapping.conf /tmp/graphite_mapping.conf

ENTRYPOINT  ["/bin/graphite_exporter", "--graphite.mapping-config=/tmp/graphite_mapping.conf"]
