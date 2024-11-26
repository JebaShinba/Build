#!/bin/bash

# Exit on errors
set -e

# Set the Windows-based output path
if [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "win32"* ]]; then
    # Windows-based paths (e.g., Git Bash or WSL)
    OUTPUT_DIR="C:/Users/jebas/Build"
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

# Variables
GITHUB_REPO="JebaShinba/Build"  # Replace with your GitHub repo
ASSET_NAME="filename.zip"       # Replace with the release asset name

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Fetch the latest release tag
echo "Fetching the latest release tag for the repository $GITHUB_REPO..."
LATEST_TAG=$(curl -s https://api.github.com/repos/$GITHUB_REPO/releases/latest | grep '"tag_name":' | awk -F'"' '{print $4}')
if [ -z "$LATEST_TAG" ]; then
  echo "Error: Unable to fetch the latest release tag."
  exit 1
fi
echo "Latest release tag: $LATEST_TAG"


echo "Fetching download URL for asset: $ASSET_NAME..."
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/$GITHUB_REPO/releases/tags/$LATEST_TAG \
  | grep -oP '(?<="browser_download_url": ")[^"]*(?=.*'"$ASSET_NAME"')')

# Verify the download URL
if [ -z "$DOWNLOAD_URL" ]; then
  echo "Error: Release asset '$ASSET_NAME' not found in the latest release."
  exit 1
fi

# Download the release asset
echo "Downloading $ASSET_NAME to $OUTPUT_DIR..."
curl -L -o "$OUTPUT_DIR/$ASSET_NAME" "$DOWNLOAD_URL"

echo "Download complete! File saved at $OUTPUT_DIR/$ASSET_NAME"
