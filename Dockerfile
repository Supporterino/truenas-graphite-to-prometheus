FROM prom/graphite-exporter:latest

COPY graphite_mapping.conf /tmp/graphite_mapping.conf

ENTRYPOINT  ["/bin/graphite_exporter", "--graphite.mapping-config=/tmp/graphite_mapping.conf"]
