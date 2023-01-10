FROM alpine:3.17.1

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

# hadolint ignore=DL3017,DL3018
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories && \
    apk --no-cache update && apk --no-cache upgrade && \
    # Install needed packages
    apk add --update --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main boost1.81-program_options && \
    apk add --update --no-cache galera-arbitrator && rm -rf /var/cache/apk/* && \
    # create needed directories
    mkdir -p /var/log/garbd/ && \
    # forward request and error logs to docker log collector
    # See https://github.com/moby/moby/issues/19616
    ln -sf /proc/1/fd/1 /var/log/garbd/garb.log

STOPSIGNAL SIGTERM
EXPOSE 4567

CMD ["/usr/sbin/garbd","--log","/var/log/garbd/garb.log","--cfg","/etc/garb/garb.cfg"]
