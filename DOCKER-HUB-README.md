# Docker Hub README Publishing Guide

This guide explains how to publish and sync your README to Docker Hub for the `langazov/freeradius` repository.

## 🎯 **Available Methods**

### Method 1: GitHub Actions (Recommended) ⚡

**Automatic sync whenever README.md changes**

1. **Setup GitHub Secrets:**
   - Go to your GitHub repository settings
   - Navigate to `Secrets and variables` > `Actions`
   - Add these secrets:
     - `DOCKERHUB_USERNAME`: Your Docker Hub username
     - `DOCKERHUB_TOKEN`: Your Docker Hub access token

2. **Create Docker Hub Token:**
   - Visit [Docker Hub Security Settings](https://hub.docker.com/settings/security)
   - Click "New Access Token"
   - Name: `github-actions-readme-sync`
   - Permissions: `Read, Write, Delete`
   - Copy the token and add it to GitHub secrets

3. **The workflow is already created:** `.github/workflows/sync-readme.yml`

4. **Usage:**
   - Simply push changes to `README.md`
   - The workflow will automatically sync to Docker Hub
   - Or trigger manually from GitHub Actions tab

### Method 2: Manual Script 🛠️

**Use the provided script for manual sync**

1. **Setup environment variables:**
   ```bash
   export DOCKER_HUB_USERNAME="langazov"
   export DOCKER_HUB_TOKEN="your_token_here"
   ```

2. **Run the sync script:**
   ```bash
   ./sync-readme-dockerhub.sh
   ```

3. **The script will:**
   - Install `hub-tool` if needed
   - Login to Docker Hub
   - Upload the README
   - Update repository description

### Method 3: During Build Process 🏗️

**Integrated with the build script**

1. **Run the secure build script:**
   ```bash
   ./build-secure.sh
   ```

2. **After successful build, you'll be prompted:**
   ```
   📄 Sync README to Docker Hub? (y/N):
   ```

3. **Choose 'y' to automatically sync the README**

### Method 4: Manual Web Interface 🌐

**Traditional manual method**

1. Go to [hub.docker.com](https://hub.docker.com)
2. Navigate to `langazov/freeradius`
3. Click "Overview" tab
4. Click "Edit" button
5. Paste your README content
6. Save changes

## 🔧 **Prerequisites**

### For GitHub Actions:
- GitHub repository with Actions enabled
- Docker Hub account and access token
- Repository secrets configured

### For Script Methods:
- Docker Hub access token
- Environment variables set
- `curl` and `tar` available (for hub-tool installation)

### For Manual Web:
- Docker Hub account access
- Web browser

## 🚀 **Quick Start**

**Recommended approach for automatic syncing:**

1. **Create Docker Hub token:**
   ```bash
   # Visit: https://hub.docker.com/settings/security
   # Create token with Read, Write, Delete permissions
   ```

2. **Add GitHub secrets:**
   ```bash
   # In GitHub repo settings > Secrets and variables > Actions:
   # DOCKERHUB_USERNAME = langazov
   # DOCKERHUB_TOKEN = dckr_pat_your_token_here
   ```

3. **Push README changes:**
   ```bash
   git add README.md
   git commit -m "Update README"
   git push origin master
   ```

4. **The GitHub Action will automatically sync to Docker Hub! ✨**

## 📋 **Verification**

After syncing, verify the README appears correctly:

1. Visit [Docker Hub Repository](https://hub.docker.com/r/langazov/freeradius)
2. Check the "Overview" tab
3. Verify README content and formatting
4. Confirm repository description is updated

## 🔍 **Troubleshooting**

### GitHub Actions Issues:
- Check the Actions tab for workflow logs
- Verify secrets are correctly set
- Ensure token has proper permissions

### Script Issues:
- Verify environment variables are set
- Check Docker Hub token validity
- Ensure network connectivity

### Manual Issues:
- Clear browser cache
- Try incognito/private mode
- Check Docker Hub service status

## 🎨 **Docker Hub Markdown Support**

Docker Hub supports a subset of Markdown:
- Headers (# ## ###)
- **Bold** and *italic* text
- `Code blocks`
- Links [text](url)
- Lists (- and 1.)
- Images ![alt](url)

**Note:** Some advanced Markdown features may not render properly on Docker Hub.

## 🔄 **Automation Benefits**

Using GitHub Actions provides:
- ✅ Automatic synchronization
- ✅ Version control integration  
- ✅ No manual intervention needed
- ✅ Consistent formatting
- ✅ Audit trail of changes
- ✅ Rollback capabilities

Choose the method that best fits your workflow! 🚀
