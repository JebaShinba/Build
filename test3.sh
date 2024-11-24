#!/bin/bash

# Repository details
REPO_OWNER="JebaShinba"
REPO_NAME="Build"
TAG="latest"  # Use "latest" for the latest release, or specify a tag like "v1.0.0"
TOKEN="${GITHUB_TOKEN}"  # Provide your GitHub token via an environment variable for security

# Determine the download directory
DOWNLOAD_DIR="./downloads"  # Use a relative path for CI/CD environments

# Ensure the download directory
mkdir -p "$DOWNLOAD_DIR"

# Construct the API URL
if [[ "$TAG" == "latest" ]]; then
  API_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest"
else
  API_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/tags/$TAG"
fi

# Fetch the release information from GitHub
if [[ -n "$TOKEN" ]]; then
  AUTH_HEADER="Authorization: token $TOKEN"
else
  AUTH_HEADER=""
fi

RELEASE_INFO=$(curl -sH "$AUTH_HEADER" "$API_URL")

# Check if the API response is valid
if [[ -z "$RELEASE_INFO" || "$(echo "$RELEASE_INFO" | jq -r '.message')" == "Not Found" ]]; then
  echo "Error: Unable to fetch release information. Check repository details and tag."
  exit 1
fi

# Parse the release asset download URLs
ASSET_URLS=$(echo "$RELEASE_INFO" | jq -r '.assets[].browser_download_url')

# Check if any assets were found
if [[ -z "$ASSET_URLS" ]]; then
  echo "No assets found for the release $TAG."
  exit 1
fi

# Download each asset
for ASSET_URL in $ASSET_URLS; do
  echo "Downloading $ASSET_URL..."
  FILENAME=$(basename "$ASSET_URL")
  OUTPUT_PATH="$DOWNLOAD_DIR/$FILENAME"

  curl -L -o "$OUTPUT_PATH" "$ASSET_URL"
  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to download $ASSET_URL"
    exit 1
  fi
done

echo "Download completed. Files saved to $DOWNLOAD_DIR."
