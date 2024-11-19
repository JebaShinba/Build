#!/bin/bash

# Repository details
REPO_OWNER="JebaShinba"
REPO_NAME="Build"
TOKEN=""      # Optional: Add your GitHub token if accessing private repositories
DOWNLOAD_DIR="$HOME/Build"  # Use Unix-style path (e.g., /home/username/Build)

# Ensure the download directory exists
mkdir -p "$DOWNLOAD_DIR"

# Fetch the latest release information
API_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest"
if [[ -n "$TOKEN" ]]; then
  RELEASE_INFO=$(curl -sH "Authorization: token $TOKEN" "$API_URL")
else
  RELEASE_INFO=$(curl -s "$API_URL")
fi

# Debugging: Print release info
echo "Release Information: $RELEASE_INFO"

# Parse the release asset download URLs
ASSET_URLS=$(echo "$RELEASE_INFO" | grep browser_download_url | cut -d '"' -f 4)

# Check if any assets were found
if [[ -z "$ASSET_URLS" ]]; then
  echo "No assets found for the latest release."
  exit 1
fi

# Download each asset
for ASSET_URL in $ASSET_URLS; do
  echo "Downloading $ASSET_URL..."
  FILENAME=$(basename "$ASSET_URL")
  curl -L -o "$DOWNLOAD_DIR/$FILENAME" "$ASSET_URL"
done

echo "Download completed. Files saved to $DOWNLOAD_DIR."
