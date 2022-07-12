FROM debian:11.4-slim

ARG BUILD_DATE
ARG BUILD_VERSION
ARG VCS_URL
ARG VCS_REF
ARG VCS_BRANCH

# See http://label-schema.org/rc1/ and https://microbadger.com/labels
LABEL maintainer="Jan Wagner <waja@cyconet.org>" \
    org.label-schema.name="Galera replication" \
    org.label-schema.description="Debian Linux container with installed galera-arbitrator package" \
    org.label-schema.vendor="Cyconet" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date="${BUILD_DATE:-unknown}" \
    org.label-schema.version="${BUILD_VERSION:-unknown}" \
    org.label-schema.vcs-url="${VCS_URL:-unknown}" \
    org.label-schema.vcs-ref="${VCS_REF:-unknown}" \
    org.label-schema.vcs-branch="${VCS_BRANCH:-unknown}" \
    org.opencontainers.image.source="https://github.com/waja/docker-garbd"

# hadolint ignore=DL3017,DL3018,DL3008
RUN apt-get update && apt-get -y upgrade && \
    # Install needed packages
    apt-get -y install --no-install-recommends galera-arbitrator-4 && \
    apt-get -y autoremove --purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* && \
    # create needed directories
    mkdir -p /var/log/garbd/ && \
    # forward request and error logs to docker log collector
    # See https://github.com/moby/moby/issues/19616
    ln -sf /proc/1/fd/1 /var/log/garbd/garb.log

STOPSIGNAL SIGTERM
EXPOSE 4567

CMD ["/usr/bin/garbd","--log","/var/log/garbd/garb.log","--cfg","/etc/garb/garb.cfg"]
