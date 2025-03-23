#!/bin/bash

# Check if the environment argument is passed
if [ -z "$1" ]; then
  echo "Usage: $0 <environment>"
  echo "Example: $0 idp-test"
  exit 1
fi

# Get the environment from the first script argument
ENVIRONMENT=$1

# Read the project name from terraform.tfvars.json
PROJECT_NAME=$(jq -r '.["project_name"]' terraform.tfvars.json)

# Read the environment account ID from terraform.tfvars.json based on the passed environment
ENV_ACCOUNT=$(jq -r --arg env "$ENVIRONMENT" '.[$env]' terraform.tfvars.json)

# Read the region from terraform.tfvars.json
REGION=$(jq -r '.["region"]' terraform.tfvars.json)

# Check if the environment account ID was found
if [ -z "$ENV_ACCOUNT" ]; then
  echo "Error: Environment account ID for '$ENVIRONMENT' not found in terraform.tfvars.json"
  exit 1
fi

# Check if the REGION was found
if [ -z "$REGION" ]; then
  echo "Error: Region not found in terraform.tfvars.json"
  exit 1
fi

# Use jq to replace the placeholders with actual values in terraform.tfvars.json
jq --arg env_account "$ENV_ACCOUNT" \
   --arg project_name "$PROJECT_NAME" \
   --arg region "$REGION" \
   --arg environment "$ENVIRONMENT" \
   '(.account, .backend_bucket_name) |= sub("\\$\\{ENV_ACCOUNT\\}"; $env_account) |
    .backend_bucket_key |= sub("\\$\\{PROJECT_NAME\\}"; $project_name) |
    .region |= sub("\\$\\{REGION\\}"; $region)|
    .env |= sub("\\$\\{ENVIRONMENT\\}"; $environment)' \
   terraform.tfvars.json > temp_terraform.tfvars.json && mv temp_terraform.tfvars.json terraform.tfvars.json

echo "Placeholders in 'terraform.tfvars.json' have been replaced successfully."


# Read the updated backend bucket name and key from terraform.tfvars.json
BACKEND_BUCKET_NAME=$(jq -r '.["backend_bucket_name"]' terraform.tfvars.json)
BACKEND_BUCKET_KEY=$(jq -r '.["backend_bucket_key"]' terraform.tfvars.json)
REGION=$(jq -r '.["region"]' terraform.tfvars.json)

# Debug: Print the values to be replaced
echo "DEBUG - BACKEND_BUCKET_NAME: $BACKEND_BUCKET_NAME"
echo "DEBUG - BACKEND_BUCKET_KEY: $BACKEND_BUCKET_KEY"
echo "DEBUG - REGION: $REGION"

# Verify that patterns exist in backend.tf using grep
echo "DEBUG - Searching for patterns in backend.tf"
grep 'bucket = ' backend.tf
grep 'key = ' backend.tf
grep 'region = ' backend.tf

# Use sed to replace placeholders in backend.tf with different delimiters and more specific matches
sed -i.bak \
    -e "s#bucket = \".*\"#bucket = \"$BACKEND_BUCKET_NAME\"#" \
    -e "s#key =  \".*\"#key = \"$BACKEND_BUCKET_KEY\"#" \
    -e "s#region =  \".*\"#region = \"$REGION\"#" \
    backend.tf

# Debug: Output the updated backend.tf to verify changes
echo "DEBUG - Updated backend.tf content:"
cat backend.tf
