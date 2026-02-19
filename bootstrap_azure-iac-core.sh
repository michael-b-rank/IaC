#!/bin/bash
#
# End-to-End Terragrunt Platform Setup Script
#
# This script performs the complete setup:
# 1. Installs the latest version of Terragrunt and sets the PATH.
# 2. Provisions the Azure Storage Account and Blob Container for remote state.
# 3. Unzips the project structure (terraform.zip) into the sandbox directory.
# 4. Updates the local 'state.hcl' and 'subscription.hcl' files with the generated details.
# 5. Executes 'terragrunt init -migrate-state' to bootstrap the environment.

# --- Configuration ---
TERRAGRUNT_REPO="gruntwork-io/terragrunt"
TERRAGRUNT_ARCH="linux_amd64"
INSTALL_PATH="$HOME/bin"
BASHRC_FILE="$HOME/.bashrc"
SANDBOX_PATH="$HOME/terraform/azure-iac-core/sandbox"
# Assuming terraform.zip is located in the user's home directory or accessible path
TERRAFORM_ZIP_SOURCE="$HOME/terraform.zip" 
STATE_HCL_PATH="$SANDBOX_PATH/state.hcl"
SUBSCRIPTION_HCL_PATH="$SANDBOX_PATH/subscription.hcl" # <-- NEW PATH VARIABLE
SA_SKU="Standard_LRS" # Standard Locally Redundant Storage

# --- Input Validation (3 Arguments Required) ---
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <RESOURCE_GROUP_NAME> <STORAGE_ACCOUNT_NAME> <BLOB_CONTAINER_NAME>"
    echo "Example: $0 rg-terraform-state whizlabsterra2025 tfstate"
    exit 1
fi

STATE_RG=$1
STORAGE_ACCOUNT_NAME=$2
BLOB_CONTAINER_NAME=$3


# ===============================================
# SECTION 1: TERRAGRUNT INSTALLATION AND PATH SETUP
# ===============================================

echo ""
echo "#####################################################"
echo "# 1. STARTING TERRAGRUNT INSTALLATION"
echo "#####################################################"

# 1.1 Fetch the latest stable release version number dynamically
echo "1.1 Fetching the latest stable Terragrunt version from GitHub..."
LATEST_VERSION=$(curl -sL "https://api.github.com/repos/${TERRAGRUNT_REPO}/releases/latest" | \
    grep '"tag_name":' | \
    sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo "WARNING: Could not determine latest version. Falling back to v0.51.0."
    LATEST_VERSION="v0.51.0"
else
    echo "      -> Latest version found: $LATEST_VERSION"
fi

BINARY_NAME="terragrunt_${TERRAGRUNT_ARCH}"
DOWNLOAD_URL="https://github.com/${TERRAGRUNT_REPO}/releases/download/${LATEST_VERSION}/${BINARY_NAME}"

# 1.2 Download the binary
echo "1.2 Downloading Terragrunt binary from $DOWNLOAD_URL..."
if ! curl -sL "${DOWNLOAD_URL}" -o "/tmp/${BINARY_NAME}"; then
    echo "FATAL ERROR: Failed to download the binary. Check the version/URL."
    exit 1
fi

# 1.3 Install the binary to $HOME/bin
echo "1.3 Installing Terragrunt to $INSTALL_PATH..."
mkdir -p "$INSTALL_PATH"
chmod +x "/tmp/${BINARY_NAME}"

if ! mv "/tmp/${BINARY_NAME}" "${INSTALL_PATH}/terragrunt"; then
    echo "FATAL ERROR: Failed to move the binary. Check if $INSTALL_PATH is writable."
    exit 1
fi
echo "      -> Terragrunt successfully installed."

# 1.4 Automate PATH Setup (Permanent and Current Session)
echo "1.4 Updating PATH environment variable..."
PATH_EXPORT="export PATH=\"$INSTALL_PATH:\$PATH\""
if ! grep -q "$PATH_EXPORT" "$BASHRC_FILE"; then
    echo "$PATH_EXPORT" >> "$BASHRC_FILE"
    echo "      -> Added '$INSTALL_PATH' permanently to $BASHRC_FILE."
fi
export PATH="$INSTALL_PATH:$PATH"
echo "      -> Updated PATH for current session."

# 1.5 Verify the installation
echo "1.5 Verifying installation..."
terragrunt --version
if [ $? -ne 0 ]; then
    echo "FATAL ERROR: Terragrunt verification failed. Cannot proceed."
    exit 1
fi
echo "--- Terragrunt installation complete. ---"


# ===============================================
# SECTION 2: AZURE REMOTE BACKEND PROVISIONING
# ===============================================

echo ""
echo "#####################################################"
echo "# 2. AZURE REMOTE BACKEND PROVISIONING"
echo "#####################################################"

# 2.1 Validate Storage Account Name (Azure requirements: 3-24 chars, lowercase letters and numbers)
echo "2.1 Validating Storage Account Name..."
if [[ ${#STORAGE_ACCOUNT_NAME} -lt 3 || ${#STORAGE_ACCOUNT_NAME} -gt 24 ]]; then
    echo "FATAL ERROR: Storage Account name must be between 3 and 24 characters long."
    exit 1
fi
if ! [[ $STORAGE_ACCOUNT_NAME =~ ^[a-z0-9]+$ ]]; then
    echo "FATAL ERROR: Storage Account name must contain only lowercase letters and numbers."
    exit 1
fi
echo "      -> Name validation passed: $STORAGE_ACCOUNT_NAME"

# 2.2 Check for Azure CLI login status and retrieve Subscription ID
echo "2.2 Verifying Azure CLI login and Subscription..."
SUBSCRIPTION_ID=$(az account show --query id -o tsv 2>/dev/null)

if [ -z "$SUBSCRIPTION_ID" ]; then
    echo "FATAL ERROR: You are not logged into Azure CLI. Please run 'az login'."
    exit 1
fi
echo "      -> Found Subscription ID: $SUBSCRIPTION_ID"

# 2.3 Get Resource Group Location (MUST EXIST)
echo "2.3 Retrieving Location for Resource Group: $STATE_RG..."
LOCATION=$(az group show --name "$STATE_RG" --query location -o tsv 2>/dev/null)

if [ -z "$LOCATION" ]; then
    echo "FATAL ERROR: Resource Group '$STATE_RG' not found."
    echo "Please ensure the Resource Group exists in the current subscription and you have 'read' permission on it."
    exit 1
fi
echo "      -> Found Location: $LOCATION"

# 2.4 Create the Storage Account
echo "2.4 Creating Storage Account ($STORAGE_ACCOUNT_NAME) in $LOCATION..."
echo "      -> This may take a few minutes..."

az storage account create \
    --name $STORAGE_ACCOUNT_NAME \
    --resource-group $STATE_RG \
    --location $LOCATION \
    --sku $SA_SKU \
    --encryption-services blob \
    --output none

if [ $? -ne 0 ]; then
    echo "FATAL ERROR: Storage Account creation failed. Ensure the name is globally unique and you have 'write' permission."
    exit 1
fi
echo "      -> Storage Account created successfully."

# 2.5 Create the Blob Container (for the state files)
echo "2.5 Creating Blob Container: $BLOB_CONTAINER_NAME..."

# Retrieve the primary storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $STATE_RG --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

# Create the container using the account key
az storage container create \
    --name $BLOB_CONTAINER_NAME \
    --account-name $STORAGE_ACCOUNT_NAME \
    --account-key $ACCOUNT_KEY \
    --public-access off \
    --output none

if [ $? -ne 0 ]; then
    echo "FATAL ERROR: Blob Container creation failed."
    exit 1
fi
echo "      -> Blob Container created successfully."


# ===============================================
# SECTION 3: SANDBOX PREPARATION
# ===============================================

echo ""
echo "#####################################################"
echo "# 3. SANDBOX PREPARATION (Unzipping terraform.zip)"
echo "#####################################################"

# Check if the zip file exists
if [ ! -f "$TERRAFORM_ZIP_SOURCE" ]; then
    echo "FATAL ERROR: Required file not found: $TERRAFORM_ZIP_SOURCE. Cannot proceed."
    exit 1
fi

# Unzip into the sandbox path (using -o to overwrite if necessary)
echo "3.1 Unzipping $TERRAFORM_ZIP_SOURCE"
unzip terraform.zip

# Find the specific files within the sandbox path and apply dos2unix
find ~/terraform -type f -exec dos2unix {} \;


# ===============================================
# SECTION 4: HCL CONFIGURATION UPDATE
# ===============================================

echo ""
echo "#####################################################"
echo "# 4. UPDATING state.hcl CONFIGURATION"
echo "#####################################################"

# Check if the state.hcl file exists (it should now exist after Section 3)
if [ ! -f "$STATE_HCL_PATH" ]; then
    echo "FATAL ERROR: Configuration file not found at $STATE_HCL_PATH. Cannot update. Check unzip step."
    exit 1
fi

# Use mktemp to create a safe temporary file for the robust substitution
TEMP_FILE=$(mktemp)

# 4.1 Update state.hcl: resource_group_name and storage_account_name
echo "4.1 Updating 'resource_group_name' and 'storage_account_name' in state.hcl..."
sed 's/\(resource_group_name\)[[:space:]]*=[[:space:]]*"rg-terraform-state"/\1 = "'"$STATE_RG"'"/g; s/\(storage_account_name\)[[:space:]]*=[[:space:]]*"whizlabsterra"/\1 = "'"$STORAGE_ACCOUNT_NAME"'"/g' "$STATE_HCL_PATH" > "$TEMP_FILE"


if [ $? -eq 0 ]; then
    # Overwrite the original file with the updated content
    mv "$TEMP_FILE" "$STATE_HCL_PATH"
    echo "      -> Successfully updated 'resource_group_name' and 'storage_account_name' in state.hcl."
else
    # Clean up temp file on failure
    rm -f "$TEMP_FILE"
    echo "FATAL ERROR: Failed to update state.hcl. Check the substitution patterns."
    exit 1
fi

# --- NEW STEP ---
echo "4.2 UPDATING subscription.hcl CONFIGURATION"

# Check if the subscription.hcl file exists
if [ ! -f "$SUBSCRIPTION_HCL_PATH" ]; then
    echo "FATAL ERROR: Configuration file not found at $SUBSCRIPTION_HCL_PATH. Cannot update."
    exit 1
fi

# Use mktemp again for the second set of substitutions
TEMP_FILE_2=$(mktemp)

# 4.2 Update subscription.hcl: resource_group_east_name
# This uses the same robust sed pattern requested by the user:
sed 's/\(resource_group_east_name\)[[:space:]]*=[[:space:]]*"rg-terraform-state"/\1 = "'"$STATE_RG"'"/g' "$SUBSCRIPTION_HCL_PATH" > "$TEMP_FILE_2"

if [ $? -eq 0 ]; then
    # Overwrite the original file with the updated content
    mv "$TEMP_FILE_2" "$SUBSCRIPTION_HCL_PATH"
    echo "      -> Successfully updated 'resource_group_east_name' in subscription.hcl."
else
    # Clean up temp file on failure
    rm -f "$TEMP_FILE_2"
    echo "FATAL ERROR: Failed to update subscription.hcl. Check the substitution pattern."
    exit 1
fi
# --- END NEW STEP ---


# ===============================================
# SECTION 5: TERRAGRUNT INIT AND MIGRATION
# ===============================================

echo ""
echo "#####################################################"
echo "# 5. EXECUTING TERRAGRUNT INIT AND MIGRATION"
echo "#####################################################"

if [ ! -d "$SANDBOX_PATH" ]; then
    echo "FATAL ERROR: Sandbox directory not found: $SANDBOX_PATH. Cannot run init."
    exit 1
fi

cd "$SANDBOX_PATH"
echo "5.1 Running 'terragrunt init -migrate-state' in $SANDBOX_PATH..."
terragrunt init -migrate-state

if [ $? -ne 0 ]; then
    echo "--- TERRAGRUNT INIT WARNING ---"
    echo "Terragrunt init failed. Your backend state configuration is ready, but manual 'init' may be required."
    exit 1
fi
echo "5.2 Terragrunt init and state migration completed successfully."
export PATH="~/bin:$PATH"

# --- Final Output ---
echo ""
echo "****************************************************************"
echo "--- E2E TERRAGRUNT PLATFORM SETUP COMPLETE ---"
echo "****************************************************************"
echo ">> The Terragrunt platform is fully bootstrapped:"
echo ""
echo "    Terragrunt Version: $(terragrunt --version | head -n 1)"
echo "    Resource Group:     $STATE_RG"
echo "    Storage Account:    $STORAGE_ACCOUNT_NAME" 
echo "    Container Name:     $BLOB_CONTAINER_NAME"
echo "    Location:           $LOCATION"
echo ""
echo ">> Your local Terraform state has been migrated to the Azure backend."
echo ">> Running final 'terragrunt plan' check..."

# 5.3 Terragrunt PLAN ALL (Added --terragrunt-non-interactive for robustness)
echo "5.3 Running 'terragrunt run-all plan' check..."
terragrunt run-all plan --terragrunt-non-interactive --non-interactive

if [ $? -ne 0 ]; then
    echo "WARNING: The final 'terragrunt plan' check failed."
    echo "This is common if dependencies haven't been applied yet. You may need to add 'mock_outputs' to your dependency blocks."
else
    echo "SUCCESS: Terragrunt plan check completed successfully. You are ready to run 'terragrunt run-all apply'."
fi
echo "****************************************************************"
export PATH="~/bin:$PATH"
cd ~/terraform/azure-iac-core/sandbox
terragrunt run --all apply --non-interactive
export PATH="~/bin:$PATH"