#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Checking iOS device automation readiness..."

# --- Detect a connected physical iOS device ---
DEVICE_LINE=$(xcrun xctrace list devices 2>/dev/null \
    | grep -E "\(.*\) \([0-9A-F-]{8,}\)" \
    | grep -v "MacBook" \
    | head -1 || true)

if [ -z "$DEVICE_LINE" ]; then
  echo "❌ No connected iOS device found."
  echo "➡️ Connect your device via USB and make sure it's trusted."
  exit 1
fi

DEVICE_ID=$(echo "$DEVICE_LINE" | grep -oE '[0-9A-F-]{8,}' | head -1 || echo "")
DEVICE_NAME=$(echo "$DEVICE_LINE" | sed -E 's/ \([0-9]+\.[0-9]+.*\)//' | xargs)
IOS_VERSION=$(ideviceinfo -u "$DEVICE_ID" -k ProductVersion 2>/dev/null || echo "unknown")

echo "📱 Device: $DEVICE_NAME"
echo "🧩 iOS version: $IOS_VERSION"
echo "🆔 UDID: $DEVICE_ID"
echo

# --- Check if ideviceinfo exists ---
if ! command -v ideviceinfo >/dev/null 2>&1; then
    echo "⚠️  libimobiledevice tools not installed."
    echo "   Install with: brew install libimobiledevice"
    exit 1
fi

# --- Check if device is paired / trusted ---
if command -v idevicepair >/dev/null 2>&1; then
    if idevicepair validate -u "$DEVICE_ID" >/dev/null 2>&1; then
        echo "✅ Device trusted / paired with this host"
    else
        echo "⚠️ Device not paired/trusted. Unlock the device and tap 'Trust This Computer'."
    fi
else
    echo "ℹ️  idevicepair not installed; cannot verify pairing."
fi

# --- Check if device is locked ---
LOCKED=$(idevicediagnostics -u "$DEVICE_ID" ioreg 2>/dev/null | grep -i "DeviceLocked" || echo "unknown")
if [[ "$LOCKED" == *"true"* ]]; then
    echo "⚠️ Device appears locked. Unlock before starting automation."
else
    echo "✅ Device unlocked"
fi
# --- Developer Mode hint (non-blocking) ---
echo
echo "ℹ️  Developer Mode note:"
echo "   • iOS 16+ does not reliably expose Developer Mode state"
echo "   • If WDA/Appium fails to launch, ensure:"
echo "     Settings → Privacy & Security → Developer Mode → ON"
# --- Helpful debug commands ---
echo
echo "💡 Debug / manual checks:"
echo "   • Full device info: ideviceinfo -u $DEVICE_ID"
echo "   • Check developer keys: ideviceinfo -u $DEVICE_ID | grep -i developer -n"
echo "   • Validate pairing: idevicepair validate -u $DEVICE_ID"
echo
echo "✅ Pre-flight check complete!"
