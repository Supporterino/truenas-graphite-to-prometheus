FROM prom/graphite-exporter:v0.16.0

LABEL maintainer="Supporterino <lars@roth-kl.de>"
LABEL version="2.0.0"
LABEL description="A Docker image for running the Graphite Exporter with a custom mapping configuration for TrueNAS."
LABEL org.opencontainers.image.source=https://github.com/Supporterino/truenas-graphite-to-prometheus
LABEL org.opencontainers.image.description="A Docker image for running the Graphite Exporter with a custom mapping configuration for TrueNAS."
LABEL org.opencontainers.image.authors="Supporterino <lars@roth-kl.de>"

COPY graphite_mapping.conf /config/graphite_mapping.conf

ENTRYPOINT  ["/bin/graphite_exporter", "--graphite.mapping-config=/config/graphite_mapping.conf"]
