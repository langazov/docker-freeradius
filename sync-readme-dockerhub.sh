#!/bin/bash

# Docker Hub README sync script
# This script uploads the README.md to Docker Hub using the hub-tool

set -e

DOCKER_REPO="langazov/freeradius"
README_FILE="README.md"

echo "🐳 Syncing README to Docker Hub..."

# Check if hub-tool is installed
if ! command -v hub-tool &> /dev/null; then
    echo "❌ hub-tool not found. Installing..."
    
    # Download and install hub-tool
    HUB_TOOL_VERSION="v0.4.6"
    case "$(uname -s)" in
        Darwin*)
            PLATFORM="darwin"
            ;;
        Linux*)
            PLATFORM="linux"
            ;;
        *)
            echo "❌ Unsupported platform: $(uname -s)"
            exit 1
            ;;
    esac
    
    case "$(uname -m)" in
        x86_64|amd64)
            ARCH="amd64"
            ;;
        arm64|aarch64)
            ARCH="arm64"
            ;;
        *)
            echo "❌ Unsupported architecture: $(uname -m)"
            exit 1
            ;;
    esac
    
    DOWNLOAD_URL="https://github.com/docker/hub-tool/releases/download/${HUB_TOOL_VERSION}/hub-tool-${PLATFORM}-${ARCH}.tar.gz"
    
    echo "📥 Downloading hub-tool from: ${DOWNLOAD_URL}"
    curl -L "${DOWNLOAD_URL}" | tar -xz
    sudo mv hub-tool /usr/local/bin/
    chmod +x /usr/local/bin/hub-tool
fi

# Check if README exists
if [[ ! -f "${README_FILE}" ]]; then
    echo "❌ README.md not found in current directory"
    exit 1
fi

# Login to Docker Hub (requires DOCKER_HUB_TOKEN environment variable)
if [[ -z "${DOCKER_HUB_TOKEN}" ]]; then
    echo "❌ DOCKER_HUB_TOKEN environment variable not set"
    echo "💡 Create a token at: https://hub.docker.com/settings/security"
    echo "💡 Then run: export DOCKER_HUB_TOKEN=your_token_here"
    exit 1
fi

if [[ -z "${DOCKER_HUB_USERNAME}" ]]; then
    echo "❌ DOCKER_HUB_USERNAME environment variable not set"
    echo "💡 Run: export DOCKER_HUB_USERNAME=your_username_here"
    exit 1
fi

echo "🔐 Logging in to Docker Hub..."
echo "${DOCKER_HUB_TOKEN}" | hub-tool login --username "${DOCKER_HUB_USERNAME}" --password-stdin

echo "📤 Uploading README to ${DOCKER_REPO}..."
hub-tool repo update "${DOCKER_REPO}" --description "FreeRADIUS server with MySQL support running as non-root user" --readme "${README_FILE}"

echo "✅ README successfully synced to Docker Hub!"
echo "🔗 View at: https://hub.docker.com/r/${DOCKER_REPO}"
