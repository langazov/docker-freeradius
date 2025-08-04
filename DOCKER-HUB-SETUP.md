# Setting Up Docker Hub Push for GitHub Actions

## Current Status
✅ **Build with SBOM/Provenance**: Works without credentials  
⚠️ **Push to Docker Hub**: Requires setup (optional)

## Quick Setup (Optional)

If you want to automatically push images to Docker Hub via GitHub Actions:

### 1. Create Docker Hub Access Token
1. Go to [Docker Hub](https://hub.docker.com/)
2. Sign in to your account
3. Go to **Account Settings** → **Security** → **New Access Token**
4. Create a token with **Read, Write, Delete** permissions
5. Copy the generated token (you won't see it again)

### 2. Configure GitHub Secrets
1. Go to your GitHub repository: `https://github.com/langazov/docker-freeradius`
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret** and add:
   - **Name**: `DOCKER_USERNAME`
   - **Value**: Your Docker Hub username (`langazov`)
4. Click **New repository secret** and add:
   - **Name**: `DOCKER_PASSWORD` 
   - **Value**: The access token you created in step 1

### 3. Test the Setup
1. Push a commit to the `master` branch
2. Check the **Actions** tab in your repository
3. The workflow should now build AND push the image with attestations

## What Happens Without Setup?

**Without Docker Hub credentials configured:**
- ✅ GitHub Actions will still run successfully
- ✅ Images are built with SBOM and provenance locally
- ⚠️ Images are NOT pushed to Docker Hub
- ✅ All security attestations are still generated
- ✅ Build completes without errors

**With Docker Hub credentials configured:**
- ✅ Everything above, PLUS:
- ✅ Images are automatically pushed to Docker Hub
- ✅ Public images include SBOM and provenance attestations
- ✅ Build attestations are attached to the registry

## Alternative: Local Building

You can always build and push manually using the provided script:

```bash
# Build locally with attestations (no push)
docker buildx build --sbom=true --provenance=true --tag langazov/freeradius:latest .

# Build and push manually (requires docker login)
./build-secure.sh
```

## Security Note

The workflow is designed to be secure:
- Only runs on the `langazov` repository
- Only pushes when proper credentials are available  
- Never exposes credentials in logs
- Uses Docker Hub access tokens (not passwords)
- Includes proper attestation generation

Your security setup is complete whether you choose to push to Docker Hub or not! 🔒
