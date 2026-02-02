#!/bin/bash
set -e

DEVICE_ID="$1"

if [[ -z "$DEVICE_ID" ]]; then
  echo "❌ No device id provided"
  echo "Usage: $0 <DEVICE_UDID>"
  exit 1
fi

echo "📱 Running on device: $DEVICE_ID"

# Resolve script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# WebDriverAgent path
WDA_PATH="${HOME}/.appium/node_modules/appium-xcuitest-driver/node_modules/appium-webdriveragent"

cd "$WDA_PATH" || { echo "Failed to cd into $WDA_PATH"; exit 1; }

# Run Xcode build
xcodebuild \
  build-for-testing \
  test-without-building \
  -project WebDriverAgent.xcodeproj \
  -scheme WebDriverAgentRunner \
  -destination "id=${DEVICE_ID}"
