# FreeRADIUS Docker Container

A secure, production-ready FreeRADIUS Docker container built on Alpine Linux with comprehensive security attestations.

[![GitHub Actions](https://github.com/langazov/docker-freeradius/workflows/Build%20and%20Push%20Docker%20Image%20with%20SBOM%20and%20Provenance/badge.svg)](https://github.com/langazov/docker-freeradius/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/langazov/freeradius.svg?style=flat-square)](https://hub.docker.com/r/langazov/freeradius)
[![Docker Stars](https://img.shields.io/docker/stars/langazov/freeradius.svg?style=flat-square)](https://hub.docker.com/r/langazov/freeradius)
[![License](https://img.shields.io/github/license/langazov/docker-freeradius.svg?style=flat-square)](https://github.com/langazov/docker-freeradius/blob/master/LICENSE)

## 🔒 Security Features

- ✅ **Non-root execution**: Runs as dedicated `radiususer` (UID 1001)
- ✅ **Software Bill of Materials (SBOM)**: Complete component inventory
- ✅ **Provenance attestation**: Cryptographic build integrity proof
- ✅ **Supply chain security**: SLSA Level 2 compliant
- ✅ **Multi-architecture**: Supports AMD64 and ARM64
- ✅ **Minimal attack surface**: Alpine Linux base with essential packages only

## 📋 Supported Tags and Versions

| Tag | Alpine Version | FreeRADIUS Version | Architecture | Security Attestations |
| --- | :---: | :---: | :---: | :---: |
| `latest`, `master` | 3.22.1 | 3.0.27-r1 | amd64, arm64 | ✅ SBOM + Provenance |
| `<git-sha>` | 3.22.1 | 3.0.27-r1 | amd64, arm64 | ✅ SBOM + Provenance |

## 🚀 Quick Start

### With Docker Run
```bash
# Basic usage with MySQL backend
docker run -d \
  --name freeradius \
  -p 1812:1812/udp \
  -p 1813:1813/udp \
  -e DB_HOST=mysql.example.com \
  -e DB_USER=radius \
  -e DB_PASS=your_password \
  langazov/freeradius:latest
```

### With Docker Compose
```yaml
version: '3.8'

services:
  freeradius:
    image: langazov/freeradius:latest
    container_name: freeradius
    ports:
      - "1812:1812/udp"
      - "1813:1813/udp"
    environment:
      - DB_HOST=mysql
      - DB_USER=radius
      - DB_PASS=radpass
      - DB_NAME=radius
      - RADIUS_KEY=your_secret_key
      - RAD_CLIENTS=10.0.0.0/24
      - RAD_DEBUG=no
    depends_on:
      - mysql
    restart: unless-stopped
    networks:
      - radius-net

  mysql:
    image: mysql:8.0
    container_name: radius-mysql
    command: --default-authentication-plugin=mysql_native_password
    environment:
      - MYSQL_ROOT_PASSWORD=rootpass
      - MYSQL_DATABASE=radius
      - MYSQL_USER=radius
      - MYSQL_PASSWORD=radpass
    volumes:
      - mysql_data:/var/lib/mysql
      - ./configs/mysql/radius.sql:/docker-entrypoint-initdb.d/radius.sql
    restart: unless-stopped
    networks:
      - radius-net

volumes:
  mysql_data:

networks:
  radius-net:
    driver: bridge
```

## ⚙️ Configuration

### Environment Variables

| Variable | Default | Description |
| --- | --- | --- |
| `DB_HOST` | `localhost` | MySQL database hostname |
| `DB_PORT` | `3306` | MySQL database port |
| `DB_USER` | `radius` | MySQL database username |
| `DB_PASS` | `radpass` | MySQL database password |
| `DB_NAME` | `radius` | MySQL database name |
| `RADIUS_KEY` | `testing123` | Shared secret for RADIUS clients |
| `RAD_CLIENTS` | `10.0.0.0/24` | Allowed RADIUS client networks |
| `RAD_DEBUG` | `no` | Enable debug mode (`yes`/`no`) |

### Volume Mounts (Optional)

```bash
# Custom user configurations
-v /path/to/users:/etc/raddb/users

# Custom client configurations  
-v /path/to/clients.conf:/etc/raddb/clients.conf

# Custom certificates
-v /path/to/certs:/etc/raddb/certs
```

## 🧪 Testing Authentication

Test your FreeRADIUS setup using the radtest client:

```bash
# Install radtest client
docker run -it --rm --network <your-network> \
  freeradius/freeradius-server:latest \
  radtest username password freeradius-container 0 your_shared_secret

# Example output for successful authentication:
# Sent Access-Request Id 42 from 0.0.0.0:48898 to 10.0.0.3:1812 length 77
# Received Access-Accept Id 42 from 10.0.0.3:1812 to 0.0.0.0:0 length 20
```

## 🔧 Building from Source

### Prerequisites
- Docker with Buildx support
- Git

### Build with Security Attestations
```bash
# Clone the repository
git clone https://github.com/langazov/docker-freeradius.git
cd docker-freeradius

# Build with SBOM and provenance (recommended)
./build-secure.sh

# Or build manually with attestations
docker buildx build \
  --sbom=true \
  --provenance=true \
  --platform linux/amd64,linux/arm64 \
  --tag langazov/freeradius:custom \
  --load \
  .
```

### Build for Local Development
```bash
# Simple local build
docker build -t freeradius-dev .

# Build without pushing
PUSH_IMAGE=false ./build-secure.sh dev
```

## 🔐 Security & Compliance

### Supply Chain Security
This image includes comprehensive security attestations:

```bash
# Verify SBOM (Software Bill of Materials)
docker buildx imagetools inspect langazov/freeradius:latest \
  --format '{{ json .SBOM }}'

# Verify provenance attestation
docker buildx imagetools inspect langazov/freeradius:latest \
  --format '{{ json .Provenance }}'
```

### Security Standards Compliance
- ✅ **SLSA Level 2**: Build integrity and provenance
- ✅ **NIST SSDF**: Secure software development practices
- ✅ **OCI Compliance**: Standard container image format
- ✅ **Non-root execution**: Principle of least privilege

### Container Security
```bash
# Verify non-root execution
docker run --rm langazov/freeradius:latest id
# Output: uid=1001(radiususer) gid=101(radius) groups=101(radius)

# Security scan example (using docker scout)
docker scout cves langazov/freeradius:latest
```

## 📜 Certificate Management

The container includes test certificates that are regenerated with each build. **These are for testing only and should be replaced in production.**

### Generate New Certificates
```bash
# Clone repository and mount volume
git clone https://github.com/langazov/docker-freeradius.git
cd docker-freeradius

# Generate new certificates
docker run -it --rm \
  -v $PWD/etc/raddb:/etc/raddb \
  langazov/freeradius:latest sh

# Inside container:
cd /etc/raddb/certs/
rm -f *.pem *.der *.csr *.crt *.key *.p12 serial* index.txt*
./bootstrap
chown -R radiususer:radius /etc/raddb/certs
chmod 640 /etc/raddb/certs/*.pem
exit

# Fix permissions for host
sudo chown -R $USER:$USER etc/raddb/certs
```

### Certificate Configuration
Modify certificate settings by editing files in `/etc/raddb/certs/`:
- `ca.cnf` - Certificate Authority settings
- `server.cnf` - Server certificate settings  
- `client.cnf` - Client certificate settings

## 🔍 Monitoring & Troubleshooting

### Debug Mode
```bash
# Enable debug output
docker run -d \
  -p 1812:1812/udp \
  -p 1813:1813/udp \
  -e RAD_DEBUG=yes \
  langazov/freeradius:latest

# View logs
docker logs <container-name>
```

### Health Checks
```bash
# Basic connectivity test
nc -u <container-ip> 1812

# RADIUS test with radtest
echo "User-Name=test,User-Password=test" | \
  radclient <container-ip>:1812 auth <shared-secret>
```

### Common Issues
1. **Connection refused**: Check firewall and port bindings
2. **Authentication failed**: Verify database connection and user credentials  
3. **Certificate errors**: Regenerate certificates or check permissions
4. **Permission denied**: Ensure container runs as non-root user

## 📚 Additional Resources

- 📖 [Security Attestations Guide](SECURITY-ATTESTATIONS.md)
- 🛠️ [Docker Hub Setup](DOCKER-HUB-SETUP.md)
- 📋 [Implementation Summary](IMPLEMENTATION-SUMMARY.md)
- 🌐 [FreeRADIUS Documentation](https://freeradius.org/documentation/)
- 🐛 [GitHub Issues](https://github.com/langazov/docker-freeradius/issues)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

**⚡ Made with security in mind** | Built on Alpine Linux | Non-root execution | SBOM + Provenance included
