#!/bin/bash

# Secure Docker build script with SBOM and Provenance
# This script builds the FreeRADIUS Docker image with security attestations

set -e

IMAGE_NAME="langazov/freeradius"
TAG="${1:-latest}"
BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
GIT_URL=$(git config --get remote.origin.url 2>/dev/null || echo "unknown")

echo "Building FreeRADIUS Docker image with security attestations..."
echo "Image: ${IMAGE_NAME}:${TAG}"
echo "Build Date: ${BUILD_DATE}"
echo "Git Commit: ${GIT_COMMIT}"
echo "Git URL: ${GIT_URL}"
echo ""

# Build with SBOM and Provenance
# Note: Requires Docker Buildx and BuildKit
docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --tag "${IMAGE_NAME}:${TAG}" \
    --tag "${IMAGE_NAME}:${GIT_COMMIT}" \
    --label "org.opencontainers.image.created=${BUILD_DATE}" \
    --label "org.opencontainers.image.revision=${GIT_COMMIT}" \
    --label "org.opencontainers.image.url=${GIT_URL}" \
    --sbom=true \
    --provenance=true \
    --push \
    .

echo ""
echo "Build completed successfully!"
echo "Image built with:"
echo "  ✓ Software Bill of Materials (SBOM)"
echo "  ✓ Provenance attestation" 
echo "  ✓ Multi-architecture support (amd64, arm64)"
echo "  ✓ Security labels and metadata"
echo ""
echo "To inspect the SBOM and provenance:"
echo "  docker buildx imagetools inspect ${IMAGE_NAME}:${TAG} --format '{{ json .Provenance }}'"
echo "  docker buildx imagetools inspect ${IMAGE_NAME}:${TAG} --format '{{ json .SBOM }}'"
