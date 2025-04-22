FROM prom/graphite-exporter:v0.16.0

LABEL maintainer="Supporterino <lars@roth-kl.de>"
LABEL org.opencontainers.image.authors="Supporterino <lars@roth-kl.de>"

COPY graphite_mapping.conf /config/graphite_mapping.conf

ENTRYPOINT  ["/bin/graphite_exporter", "--graphite.mapping-config=/config/graphite_mapping.conf"]
