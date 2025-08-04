FROM alpine:3.22.1

LABEL maintainer="Emil Langazov <langazov@gmail.com>"

# Image details
LABEL eu.imsc.image.title="FreeRADIUS Server" \
      eu.imsc.image.description="FreeRADIUS server with MySQL support running as non-root user" \
      eu.imsc.image.vendor="Emil Langazov" \
      eu.imsc.image.licenses="MIT" \
      eu.imsc.image.source="https://github.com/langazov/docker-freeradius" \
      eu.imsc.image.documentation="https://github.com/langazov/docker-freeradius/blob/master/README.md" \
      eu.imsc.image.base.name="docker.io/library/alpine:3.22.1"

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
