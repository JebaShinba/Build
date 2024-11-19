#!/bin/bash

# Repository details
REPO_OWNER="JebaShinba"
REPO_NAME="Build"
TAG="latest"  # Use "latest" for the latest release, or specify a tag like "v1.0.0"
TOKEN=""      # Optional: Add your GitHub token if accessing private repositories

# Determine the download directory based on the operating system
if [[ "$(uname)" == "Linux" || "$(uname)" == "Darwin" ]]; then
  # Unix-based systems (Linux/macOS)
  DOWNLOAD_DIR="$HOME/Build"
else
  # Windows (Git Bash, etc.)
  DOWNLOAD_DIR="C:/Users/jebas"
fi

# Ensure the download directory exists
mkdir -p "$DOWNLOAD_DIR"

# Fetch the release information from GitHub
if [[ -n "$TOKEN" ]]; then
  AUTH_HEADER="Authorization: token $TOKEN"
else
  AUTH_HEADER=""
fi

API_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/$TAG"
RELEASE_INFO=$(curl -sH "$AUTH_HEADER" "$API_URL")

# Parse the release asset download URLs
ASSET_URLS=$(echo "$RELEASE_INFO" | grep browser_download_url | cut -d '"' -f 4)

# Check if any assets were found
if [[ -z "$ASSET_URLS" ]]; then
  echo "No assets found for the release $TAG."
  exit 1
fi

# Download each asset
for ASSET_URL in $ASSET_URLS; do
  echo "Downloading $ASSET_URL..."
  FILENAME=$(basename "$ASSET_URL")

  if [[ "$(uname)" == "Linux" || "$(uname)" == "Darwin" ]]; then
    # Unix-based systems
    OUTPUT_PATH="$DOWNLOAD_DIR/$FILENAME"
  else
    # Windows systems
    OUTPUT_PATH=$(cygpath -w "$DOWNLOAD_DIR/$FILENAME")
  fi

  curl -L -o "$OUTPUT_PATH" "$ASSET_URL"
done

echo "Download completed. Files saved to $DOWNLOAD_DIR."


