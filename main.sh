#!/bin/bash

# Ensure the user has provided a GitHub URL
if [ -z "$1" ]; then
    echo "Usage: git-curl [github_url]"
    exit 1
fi

# Extract the owner and repository from the provided GitHub URL
GITHUB_URL="$1"
OWNER=$(echo "$GITHUB_URL" | sed -E 's|https://github.com/([^/]+)/([^/]+)|\1|')
REPO=$(echo "$GITHUB_URL" | sed -E 's|https://github.com/([^/]+)/([^/]+)|\2|')

# GitHub API URL to fetch releases
API_URL="https://api.github.com/repos/$OWNER/$REPO/releases"

# Fetch the list of releases
releases=$(curl -s "$API_URL" | jq -r '.[].name')

# Use dialog (or fzf) for release selection
release=$(echo "$releases" | fzf --prompt="Select a Release: ")

if [ -z "$release" ]; then
    echo "No release selected."
    exit 1
fi

# Fetch assets for the selected release
assets_url="https://api.github.com/repos/$OWNER/$REPO/releases/tags/$release"
assets=$(curl -s "$assets_url" | jq -r '.assets[].name')

# Use fzf to select an asset (file)
asset=$(echo "$assets" | fzf --prompt="Select an Asset: ")

if [ -z "$asset" ]; then
    echo "No asset selected."
    exit 1
fi

# Fetch the download URL for the selected asset
asset_url=$(curl -s "$assets_url" | jq -r ".assets[] | select(.name==\"$asset\") | .browser_download_url")

# Download the selected asset
echo "Downloading $asset..."
curl -L "$asset_url" -o "$asset"

echo "Downloaded $asset"
