#!/bin/bash

# Variables
TAG="v1.0.0"  # Replace with your release tag
REPO_OWNER="JebaShinba"  # Replace with your GitHub username or organization
REPO_NAME="Build"  # Replace with your repository name

# Download release asset
echo "Downloading release asset for tag $TAG..."
wget -O release.zip "https://github.com/$REPO_OWNER/$REPO_NAME/releases/download/$TAG/filename.zip"

# Extract release asset
echo "Extracting release..."
unzip filename.zip -d 

# Deploy application
echo "Running deployment script..."
chmod +x ./deploy.sh
./deploy.sh
