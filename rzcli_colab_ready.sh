#!/usr/bin/env bash
set -e

# ==========================
# Config
# ==========================
ARTIFACT_REGISTRY_URL="https://us-central1-python.pkg.dev/renzvos-workplace/rzcli/simple/"
PACKAGE_NAME="rzcli"

# ==========================
# Validate Argument
# ==========================
if [ -z "$1" ]; then
  echo "Usage: ./colab_ready.sh <GCLOUD_ACCESS_TOKEN>"
  exit 1
fi
ACCESS_TOKEN="$1"

# ==========================
# Check for gcloud
# ==========================
if ! command -v gcloud &> /dev/null; then
  echo "gcloud not found. Installing Google Cloud SDK..."
  curl -sSL https://sdk.cloud.google.com | bash

  export PATH="$HOME/google-cloud-sdk/bin:$PATH"
  if [ -f "$HOME/.bashrc" ]; then
      source "$HOME/.bashrc"
  fi
fi

echo "gcloud version:"
gcloud --version || echo "gcloud installed but version check failed"

# ==========================
# Install Python Package
# ==========================
echo "Installing ${PACKAGE_NAME} from Artifact Registry..."
pip install --upgrade pip

pip install "${PACKAGE_NAME}" \
  --index-url "https://oauth2accesstoken:${ACCESS_TOKEN}@us-central1-python.pkg.dev/renzvos-workplace/rzcli/simple/"

echo "Installation complete."
