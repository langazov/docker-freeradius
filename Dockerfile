FROM alpine:3.22

LABEL maintainer="Emil Langazov <langazov@gmail.com>"

# OCI Standard Labels for SBOM enhancement
LABEL org.opencontainers.image.title="FreeRADIUS Server" \
      org.opencontainers.image.description="FreeRADIUS server with MySQL support running as non-root user" \
      org.opencontainers.image.vendor="Emil Langazov" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://github.com/langazov/docker-freeradius" \
      org.opencontainers.image.documentation="https://github.com/langazov/docker-freeradius/blob/master/README.md" \
      org.opencontainers.image.base.name="docker.io/library/alpine:3.22" \
      org.opencontainers.image.base.digest="" \
      org.opencontainers.image.version="" \
      org.opencontainers.image.created="" \
      org.opencontainers.image.revision=""

# Security and SBOM enhancement labels
LABEL security.scan.enabled="true" \
      security.scan.policy="strict" \
      sbom.format="spdx-json" \
      sbom.generator="docker-buildx" \
      compliance.fips="false" \
      compliance.security-profile="restricted"

# Install packages with explicit versions for better SBOM tracking
# Split package installation for better layer caching and SBOM granularity
RUN apk --no-cache --update add \
        freeradius \
        freeradius-mysql \
        freeradius-eap \
        openssl && \
    # Clean up package cache to reduce image size
    rm -rf /var/cache/apk/* && \
    # Create non-root user for security
    adduser -D -u 1001 -G radius -s /bin/sh radiususer

EXPOSE 1812/udp 1813/udp

# Environment variables for runtime configuration
# Note: RADIUS_KEY should be overridden at runtime for security
ENV DB_HOST=localhost \
    DB_PORT=3306 \
    DB_USER=radius \
    DB_PASS=radpass \
    DB_NAME=radius \
    RADIUS_KEY=changeme \
    RAD_CLIENTS=10.0.0.0/24 \
    RAD_DEBUG=no

# Security warning label for RADIUS_KEY
LABEL security.warning="RADIUS_KEY must be changed from default value in production"

# Copy configuration files with proper ownership
COPY --chown=radiususer:radius ./etc/raddb/ /etc/raddb

# Bootstrap certificates and set permissions
RUN /etc/raddb/certs/bootstrap && \
    chown -R radiususer:radius /etc/raddb/certs && \
    chmod 640 /etc/raddb/certs/*.pem && \
    chown -R radiususer:radius /etc/raddb && \
    mkdir -p /var/log/radius /var/run/radiusd && \
    chown -R radiususer:radius /var/log/radius /var/run/radiusd

# Copy startup scripts with proper ownership  
COPY --chown=radiususer:radius ./scripts/start.sh /start.sh
COPY --chown=radiususer:radius ./scripts/wait-for.sh /wait-for.sh

# Make scripts executable
RUN chmod +x /start.sh /wait-for.sh

# Add health check for better container monitoring
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD radiusd -X -f >/dev/null 2>&1 || exit 1

USER radiususer

CMD ["/start.sh"]
