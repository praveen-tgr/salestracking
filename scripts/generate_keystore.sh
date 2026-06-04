#!/usr/bin/env bash
# generate_keystore.sh
#
# Generates a release keystore and prints the base64-encoded value you need to
# add as a GitHub Actions secret (KEYSTORE_BASE64).
#
# Usage:
#   chmod +x scripts/generate_keystore.sh
#   ./scripts/generate_keystore.sh
#
# Then add the following secrets to your GitHub repository
# (Settings → Secrets and variables → Actions → New repository secret):
#
#   KEYSTORE_BASE64   — the base64 output printed by this script
#   KEY_ALIAS         — the alias you chose (default: release)
#   KEY_PASSWORD      — the key password you entered
#   STORE_PASSWORD    — the store password you entered

set -euo pipefail

KEYSTORE_FILE="release.keystore"
KEY_ALIAS="${KEY_ALIAS:-release}"

echo "=== Android Release Keystore Generator ==="
echo ""
echo "This will create '${KEYSTORE_FILE}' in the current directory."
echo "Keep this file safe and do NOT commit it to version control."
echo ""

keytool -genkeypair \
  -v \
  -keystore "${KEYSTORE_FILE}" \
  -alias "${KEY_ALIAS}" \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000

echo ""
echo "=== Base64-encoded keystore (copy this as the KEYSTORE_BASE64 secret) ==="
echo ""
base64 -w 0 "${KEYSTORE_FILE}"
echo ""
echo ""
echo "=== Done ==="
echo "Add these four secrets to GitHub Actions:"
echo "  KEYSTORE_BASE64  → the base64 string printed above"
echo "  KEY_ALIAS        → ${KEY_ALIAS}"
echo "  KEY_PASSWORD     → the key password you just set"
echo "  STORE_PASSWORD   → the store password you just set"
