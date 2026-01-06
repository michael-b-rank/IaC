#!/bin/bash
#
# Terragrunt Installation Script for Azure Cloud Shell (Linux AMD64)
#
# This script automatically detects the latest version of Terragrunt,
# downloads the corresponding binary, installs it to a user-writable path (~/bin),
# and verifies the installation.

# --- Configuration ---
TERRAGRUNT_REPO="gruntwork-io/terragrunt"
TERRAGRUNT_ARCH="linux_amd64"
# IMPORTANT FIX: Installing to $HOME/bin to avoid the 'sudo' permission error 
INSTALL_PATH="$HOME/bin" 

echo "--- Starting Terragrunt Installation in Azure Cloud Shell ---"

# 1. Fetch the latest stable release version number dynamically
echo "1. Fetching the latest stable Terragrunt version from GitHub..."
# Note: GitHub API calls can sometimes be rate-limited.
LATEST_VERSION=$(curl -sL "https://api.github.com/repos/${TERRAGRAGRUNT_REPO}/releases/latest" | \
    grep '"tag_name":' | \
    sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo "ERROR: Could not automatically determine the latest version."
    echo "Falling back to known stable version v0.51.0."
    LATEST_VERSION="v0.51.0"
else
    echo "   -> Latest version found: $LATEST_VERSION"
fi

# Construct the full download file name
BINARY_NAME="terragrunt_${TERRAGRUNT_ARCH}"
DOWNLOAD_URL="https://github.com/${TERRAGRUNT_REPO}/releases/download/${LATEST_VERSION}/${BINARY_NAME}"

# 2. Download the binary
echo "2. Downloading Terragrunt binary from $DOWNLOAD_URL..."
if curl -sL "${DOWNLOAD_URL}" -o "/tmp/${BINARY_NAME}"; then
    echo "   -> Download complete."
else
    echo "FATAL ERROR: Failed to download the binary. Please check the version/URL."
    exit 1
fi

# 3. Create install path and install the binary
echo "3. Creating installation directory and setting permissions..."

# Create the directory if it doesn't exist
mkdir -p "$INSTALL_PATH"

# Apply execute permissions
chmod +x "/tmp/${BINARY_NAME}"

# Move the file to the installation path and rename it to 'terragrunt'
# We no longer use 'sudo' as we are moving it to the user's home directory.
if mv "/tmp/${BINARY_NAME}" "${INSTALL_PATH}/terragrunt"; then
    echo "   -> Terragrunt successfully installed to ${INSTALL_PATH}/terragrunt."
else
    echo "FATAL ERROR: Failed to move the binary. Check if $INSTALL_PATH is writable."
    exit 1
fi

# 4. Verify the installation
echo "4. Verifying installation..."
# Temporarily add the install path to PATH for immediate verification
export PATH="$INSTALL_PATH:$PATH"
terragrunt --version

if [ $? -eq 0 ]; then
    echo "--- Terragrunt installation successful! ---"
    echo ""
    echo "*****************************************************************************************"
    echo "  >> NEXT STEP REQUIRED: To make 'terragrunt' available in future sessions,"
    echo "  >> you must add '$INSTALL_PATH' to your system's PATH."
    echo "  >> "
    echo "  >> Run this command now: export PATH=\"$INSTALL_PATH:\$PATH\""
    echo "  >> To make this permanent, add the above command to your ~/.bashrc file."
    echo "*****************************************************************************************"
else
    echo "--- WARNING: Terragrunt verification failed. Please check the script output for errors. ---"
fi

echo "--- Installation Script Finished ---"
export PATH="~/bin:$PATH"