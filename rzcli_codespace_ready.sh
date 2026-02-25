#!/usr/bin/env bash
set -euo pipefail

# ==========================
# Security: Ensure Codespaces
# ==========================
if [ -z "${CODESPACES:-}" ]; then
  echo "This script is intended to run inside GitHub Codespaces only."
  exit 1
fi

# ==========================
# Config
# ==========================
PROJECT_ID="renzvos-workplace"
REGION="us-central1"
REPOSITORY="rzcli"
PACKAGE_NAME="rzcli"
KEY_FILE="/tmp/gcp-key.json"

# ==========================
# Validate Secret
# ==========================
if [ -z "${ARTIFACTORY_READ_KEY:-}" ]; then
  echo "ARTIFACTORY_READ_KEY secret not found."
  exit 1
fi

# ==========================
# Write Key Securely
# ==========================
umask 077
echo "$ARTIFACTORY_READ_KEY" > "$KEY_FILE"
export GOOGLE_APPLICATION_CREDENTIALS="$KEY_FILE"

# ==========================
# Authenticate
# ==========================
gcloud auth activate-service-account --key-file="$KEY_FILE" --quiet
gcloud config set project "$PROJECT_ID" --quiet

# Remove key immediately after activation
rm -f "$KEY_FILE"

# ==========================
# Install Package
# ==========================
pip install --upgrade pip --quiet

pip install "$PACKAGE_NAME" \
  --extra-index-url "https://${REGION}-python.pkg.dev/${PROJECT_ID}/${REPOSITORY}/simple/" \
  --quiet

echo "rzcli ready."
