# iOS WebDriverAgent Tool

A collection of shell scripts to help with iOS device automation using WebDriverAgent (WDA).

## Overview

This repository provides utility scripts for setting up and testing iOS device automation with WebDriverAgent, commonly used with Appium for iOS testing.

## Prerequisites

Before using these tools, ensure you have the following installed:

- **Xcode** - Latest version recommended
- **Xcode Command Line Tools** - Install with: `xcode-select --install`
- **libimobiledevice** - Install with: `brew install libimobiledevice`
- **Appium with XCUITest driver** - The scripts expect WebDriverAgent to be installed via Appium:
  ```bash
  npm install -g appium
  appium driver install xcuitest
  ```
- **Physical iOS device** - Connected via USB and trusted
- **iOS 16+** - Developer Mode must be enabled in Settings → Privacy & Security → Developer Mode

## Scripts

### 1. wda_preflight_check.sh

Performs a comprehensive check of your iOS device automation readiness.

**What it checks:**
- Connected iOS device detection
- Device pairing/trust status
- Device lock status
- libimobiledevice tools installation
- Developer Mode requirements (iOS 16+)

**Usage:**
```bash
./wda_preflight_check.sh
```

**Example output:**
```
🔍 Checking iOS device automation readiness...
📱 Device: iPhone 14 Pro
🧩 iOS version: 16.2
🆔 UDID: 00008110-001234567890001E
✅ Device trusted / paired with this host
✅ Device unlocked
✅ Pre-flight check complete!
```

### 2. init_wda_local_iphone.sh

Builds and launches WebDriverAgent on a specific iOS device.

**Usage:**
```bash
./init_wda_local_iphone.sh <DEVICE_UDID>
```

**Arguments:**
- `DEVICE_UDID` - The UDID of your iOS device (obtain from `wda_preflight_check.sh` or Xcode)

**Example:**
```bash
./init_wda_local_iphone.sh 00008110-001234567890001E
```

**What it does:**
- Navigates to the WebDriverAgent installation directory
- Builds the WebDriverAgent.xcodeproj for testing
- Runs the WebDriverAgentRunner on your specified device

## Quick Start

1. **Check your device setup:**
   ```bash
   ./wda_preflight_check.sh
   ```

2. **Get your device UDID from the output** (or use `xcrun xctrace list devices`)

3. **Launch WebDriverAgent on your device:**
   ```bash
   ./init_wda_local_iphone.sh <YOUR_DEVICE_UDID>
   ```

## Troubleshooting

### No device found
- Ensure your iOS device is connected via USB
- Trust the computer on your iOS device when prompted
- Check connection with: `xcrun xctrace list devices`

### libimobiledevice tools not installed
```bash
brew install libimobiledevice
```

### Device not paired/trusted
- Unlock your iOS device
- Tap "Trust This Computer" when prompted
- Verify with: `idevicepair validate -u <DEVICE_UDID>`

### WebDriverAgent path not found
The script expects WebDriverAgent at:
```
~/.appium/node_modules/appium-xcuitest-driver/node_modules/appium-webdriveragent
```

Ensure Appium and the XCUITest driver are installed:
```bash
npm install -g appium
appium driver install xcuitest
```

### Developer Mode (iOS 16+)
If WDA fails to launch on iOS 16 or later:
- Go to Settings → Privacy & Security → Developer Mode
- Toggle Developer Mode ON
- Restart your device when prompted

### Code signing issues
If you encounter code signing errors:
1. Open the WebDriverAgent project in Xcode
2. Select the WebDriverAgentRunner target
3. Update the Bundle Identifier
4. Select your development team in Signing & Capabilities
5. Build the project once manually to resolve signing

## Requirements

- macOS with Xcode installed
- Physical iOS device (simulators have different requirements)
- USB connection to iOS device
- Valid Apple Developer account for code signing

## License

This project is provided as-is for use with iOS automation testing.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.
