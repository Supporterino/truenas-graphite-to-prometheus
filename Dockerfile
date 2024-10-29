FROM prom/graphite-exporter:v0.16.0

COPY graphite_mapping.conf /config/graphite_mapping.conf

ENTRYPOINT  ["/bin/graphite_exporter", "--graphite.mapping-config=/config/graphite_mapping.conf"]
