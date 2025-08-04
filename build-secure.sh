#!/bin/bash

# Secure Docker build script with SBOM and Provenance
# This script builds the FreeRADIUS Docker image with security attestations

set -e

IMAGE_NAME="langazov/freeradius"
TAG="${1:-latest}"
BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
SHORT_SHA=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
GIT_URL=$(git config --get remote.origin.url 2>/dev/null || echo "unknown")

echo "Building FreeRADIUS Docker image with security attestations..."
echo "Image: ${IMAGE_NAME}:${SHORT_SHA}"
echo "Build Date: ${BUILD_DATE}"
echo "Git SHA: ${SHORT_SHA}"
echo "Git URL: ${GIT_URL}"
echo ""

# Check if user wants to push
PUSH_IMAGE="${PUSH_IMAGE:-true}"
if [[ "$PUSH_IMAGE" == "false" ]]; then
    echo "Building locally (no push)..."
    PUSH_FLAG="--load"
else
    echo "Building and pushing to registry..."
    PUSH_FLAG="--push"
    
    # Check if user is logged in to Docker Hub
    if ! docker buildx ls >/dev/null 2>&1; then
        echo "⚠️  Docker Buildx not available. Using regular docker build..."
        docker build \
            # --tag "${IMAGE_NAME}:${SHORT_SHA}" \
            --tag "${IMAGE_NAME}:${SHORT_SHA}" \
            --label "org.opencontainers.image.created=${BUILD_DATE}" \
            --label "org.opencontainers.image.revision=${SHORT_SHA}" \
            --label "org.opencontainers.image.url=${GIT_URL}" \
            .
        echo "⚠️  Note: SBOM and provenance require Docker Buildx. Image built without attestations."
        exit 0
    fi
fi

# Build with SBOM and Provenance
# Note: Requires Docker Buildx and BuildKit
docker buildx build \
    --platform linux/amd64,linux/arm64 \
    # --tag "${IMAGE_NAME}:${SHORT_SHA}" \
    --tag "${IMAGE_NAME}:${SHORT_SHA}" \
    --label "org.opencontainers.image.created=${BUILD_DATE}" \
    --label "org.opencontainers.image.revision=${SHORT_SHA}" \
    --label "org.opencontainers.image.url=${GIT_URL}" \
    --sbom=true \
    --provenance=true \
    ${PUSH_FLAG} \
    .

echo ""
echo "Build completed successfully!"
echo "Image built with:"
echo "  ✓ Software Bill of Materials (SBOM)"
echo "  ✓ Provenance attestation" 
echo "  ✓ Multi-architecture support (amd64, arm64)"
echo "  ✓ Security labels and metadata"
echo ""

if [[ "$PUSH_IMAGE" == "false" ]]; then
    echo "Image available locally as: ${IMAGE_NAME}:${SHORT_SHA}"
    echo ""
    echo "To push later, run:"
    echo "  docker push ${IMAGE_NAME}:${SHORT_SHA}"
else
    echo "To inspect the SBOM and provenance:"
    echo "  docker buildx imagetools inspect ${IMAGE_NAME}:${SHORT_SHA} --format '{{ json .Provenance }}'"  
    echo "  docker buildx imagetools inspect ${IMAGE_NAME}:${SHORT_SHA} --format '{{ json .SBOM }}'"
    
    # Ask if user wants to sync README to Docker Hub
    echo ""
    read -p "📄 Sync README to Docker Hub? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [[ -f "./sync-readme-dockerhub.sh" ]]; then
            echo "🐳 Syncing README to Docker Hub..."
            ./sync-readme-dockerhub.sh
        else
            echo "⚠️  sync-readme-dockerhub.sh not found. Please run it manually or use GitHub Actions."
        fi
    fi
fi

echo ""
echo "To build locally without pushing:"
echo "  PUSH_IMAGE=false ./build-secure.sh"
