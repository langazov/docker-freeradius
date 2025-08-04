FROM alpine:3.22.1

MAINTAINER Emil Langazov <langazov@gmail.com>

# Use docker build --pull -t langazov/freeradius . --sbom=true --provenance=true

# Image details
LABEL net.2stacks.name="2stacks" \
      net.2stacks.license="MIT" \
      net.2stacks.description="Dockerfile for autobuilds" \
      net.2stacks.url="http://www.2stacks.net" \
      net.2stacks.vcs-type="Git" \
      net.2stacks.version="1.5.1" \
      net.2stacks.radius.version="v3.0.26-r2" \
      org.opencontainers.image.title="FreeRADIUS Server" \
      org.opencontainers.image.description="FreeRADIUS server with MySQL support running as non-root user" \
      org.opencontainers.image.vendor="Emil Langazov" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://github.com/langazov/docker-freeradius" \
      org.opencontainers.image.documentation="https://github.com/langazov/docker-freeradius/blob/master/README.md" \
      org.opencontainers.image.base.name="docker.io/library/alpine:3.22.1"

RUN apk --update add freeradius freeradius-mysql freeradius-eap openssl && \
    adduser -D -u 1001 -G radius -s /bin/sh radiususer

EXPOSE 1812/udp 1813/udp

ENV DB_HOST=localhost
ENV DB_PORT=3306
ENV DB_USER=radius
ENV DB_PASS=radpass
ENV DB_NAME=radius
ENV RADIUS_KEY=testing123
ENV RAD_CLIENTS=10.0.0.0/24
ENV RAD_DEBUG=no

ADD --chown=radiususer:radius ./etc/raddb/ /etc/raddb
RUN /etc/raddb/certs/bootstrap && \
    chown -R radiususer:radius /etc/raddb/certs && \
    chmod 640 /etc/raddb/certs/*.pem && \
    chown -R radiususer:radius /etc/raddb && \
    mkdir -p /var/log/radius /var/run/radiusd && \
    chown -R radiususer:radius /var/log/radius /var/run/radiusd


ADD --chown=radiususer:radius ./scripts/start.sh /start.sh
ADD --chown=radiususer:radius ./scripts/wait-for.sh /wait-for.sh

RUN chmod +x /start.sh /wait-for.sh

USER radiususer

CMD ["/start.sh"]
