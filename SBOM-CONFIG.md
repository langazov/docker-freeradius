# SBOM Configuration for FreeRADIUS Docker Image
# This file documents SBOM generation settings and best practices

# SBOM Generation Settings
# ========================

# Format: SPDX JSON (default for Docker Buildx)
# Generator: docker-buildx with BuildKit
# Compliance: NTIA minimum elements

# Key Components Tracked in SBOM:
# - Base OS: Alpine Linux 3.22.1
# - FreeRADIUS: 3.0.27-r1
# - OpenSSL: 3.3.2-r1
# - MySQL client libraries
# - Custom configuration files
# - Startup scripts

# SBOM Enhancement Features:
# ==========================

1. **Explicit Package Versions**
   - All Alpine packages pinned to specific versions
   - Enables precise vulnerability tracking
   - Improves reproducible builds

2. **OCI Standard Labels**
   - Complete metadata for image identification
   - Source repository tracking
   - Build timestamp and revision info

3. **Security Context**
   - Non-root user execution (UID 1001)
   - Minimal attack surface
   - Health check implementation

4. **Build Attestation**
   - Provenance tracking enabled
   - Multi-architecture support
   - Signed attestations

# SBOM Verification Commands:
# ===========================

# View SBOM:
# docker buildx imagetools inspect langazov/freeradius:latest --format '{{ json .SBOM }}'

# View Provenance:
# docker buildx imagetools inspect langazov/freeradius:latest --format '{{ json .Provenance }}'

# Extract SBOM to file:
# docker buildx imagetools inspect langazov/freeradius:latest --format '{{ json .SBOM }}' > sbom.json

# Compliance Notes:
# ================
# - NTIA SBOM minimum elements: ✓
# - SPDX format compatibility: ✓
# - Supply chain security: ✓
# - Vulnerability scanning ready: ✓
