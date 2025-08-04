# Security Attestations

This Docker image is built with comprehensive security attestations including:

## 🔒 Software Bill of Materials (SBOM)

The SBOM provides a complete inventory of all software components in the image, helping with:
- Vulnerability scanning and management
- License compliance
- Supply chain security
- Dependency tracking

## 🛡️ Provenance Attestation

Provenance attestation provides cryptographic proof of:
- How the image was built
- Where it was built
- What source code was used
- Build environment details
- Build parameters and configuration

## Building with Attestations

### Option 1: Using the build script
```bash
./build-secure.sh [tag]
```

### Option 2: Manual build with Docker Buildx
```bash
# Enable buildx if not already enabled
docker buildx create --use

# Build with SBOM and provenance
docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --tag langazov/freeradius:latest \
    --sbom=true \
    --provenance=true \
    --push \
    .
```

## Verifying Attestations

### Inspect SBOM
```bash
# View SBOM in JSON format
docker buildx imagetools inspect langazov/freeradius:latest --format '{{ json .SBOM }}'

# Extract SBOM to a file
docker buildx imagetools inspect langazov/freeradius:latest --format '{{ json .SBOM }}' > sbom.json
```

### Inspect Provenance
```bash
# View provenance attestation
docker buildx imagetools inspect langazov/freeradius:latest --format '{{ json .Provenance }}'

# Extract provenance to a file  
docker buildx imagetools inspect langazov/freeradius:latest --format '{{ json .Provenance }}' > provenance.json
```

### Using cosign (for signature verification)
```bash
# Install cosign
curl -O -L "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64"
sudo mv cosign-linux-amd64 /usr/local/bin/cosign
sudo chmod +x /usr/local/bin/cosign

# Verify image signature (if signed)
cosign verify langazov/freeradius:latest
```

## Security Labels

The image includes standard OCI labels for better metadata and security:

- `org.opencontainers.image.title`: Human-readable title
- `org.opencontainers.image.description`: Image description
- `org.opencontainers.image.vendor`: Vendor information
- `org.opencontainers.image.licenses`: License information
- `org.opencontainers.image.source`: Source code repository
- `org.opencontainers.image.documentation`: Documentation URL
- `org.opencontainers.image.created`: Build timestamp
- `org.opencontainers.image.revision`: Git commit hash
- `org.opencontainers.image.base.name`: Base image information

## CI/CD Integration

The included GitHub Actions workflow (`.github/workflows/docker-build.yml`) automatically:

1. ✅ Builds multi-architecture images (amd64, arm64)
2. ✅ Generates SBOM for all dependencies
3. ✅ Creates provenance attestation
4. ✅ Attaches build attestation
5. ✅ Pushes to Docker Hub with all attestations
6. ✅ Provides verification commands

## Compliance and Standards

This setup follows:

- **SLSA (Supply-chain Levels for Software Artifacts)** framework
- **NIST SSDF (Secure Software Development Framework)** guidelines  
- **OCI (Open Container Initiative)** image specifications
- **SPDX (Software Package Data Exchange)** format for SBOM
- **in-toto** attestation framework for provenance

## Benefits

✅ **Supply Chain Security**: Complete visibility into image components  
✅ **Vulnerability Management**: Easy identification of vulnerable components  
✅ **Compliance**: Meet regulatory and organizational security requirements  
✅ **Trust**: Cryptographic proof of build integrity  
✅ **Auditability**: Full trail of what was built and how  
