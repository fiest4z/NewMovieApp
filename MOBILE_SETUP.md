# Mobile Device Setup Guide

## Quick Test Options

You can now run the app on:
- **Web (Chrome/Edge)**: `flutter run -d chrome` ✅ (Currently running)
- **Windows Desktop**: `flutter run -d windows`
- **Android Emulator**: See instructions below
- **Physical Device**: See instructions below

## Setting Up Android Emulator

### Step 1: Open Android Studio

1. Launch Android Studio
2. Click "More Actions" → "Virtual Device Manager" (or Tools → Device Manager)

### Step 2: Create a Virtual Device

1. Click "Create Device"
2. Select a device (e.g., "Pixel 5" or "Pixel 6")
3. Click "Next"
4. Select a system image (e.g., "Tiramisu" API 33 or latest)
   - If not downloaded, click "Download" next to the system image
5. Click "Next" → "Finish"

### Step 3: Start the Emulator

1. In Virtual Device Manager, click the ▶️ play button next to your device
2. Wait for the emulator to boot (may take a minute)

### Step 4: Run Your App

Once the emulator is running:
```powershell
flutter run
```

Flutter will automatically detect the emulator and install your app.

## Using a Physical Android Device

### Step 1: Enable Developer Options

1. Go to Settings → About Phone
2. Tap "Build Number" 7 times
3. Go back to Settings → Developer Options
4. Enable "USB Debugging"

### Step 2: Connect Your Device

1. Connect your phone via USB
2. On your phone, allow USB debugging when prompted
3. Verify connection:
   ```powershell
   flutter devices
   ```

### Step 3: Run Your App

```powershell
flutter run
```

## Using a Physical iOS Device (Mac only)

1. Connect your iPhone/iPad via USB
2. Trust the computer on your device
3. Open Xcode → Window → Devices and Simulators
4. Select your device and click "Use for Development"
5. Run: `flutter run`

## Useful Commands

```powershell
# List all available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run on Chrome
flutter run -d chrome

# Run on Windows
flutter run -d windows

# Run on Android emulator (if only one is running)
flutter run -d android

# Hot reload (press 'r' while app is running)
# Hot restart (press 'R' while app is running)
# Quit (press 'q' while app is running)
```

## Troubleshooting

### Emulator is slow
- Close other applications
- Increase RAM allocation in AVD settings
- Use a system image with lower API level

### Device not detected
- For Android: Make sure USB debugging is enabled
- For iOS: Make sure device is trusted and Xcode is configured
- Run `flutter doctor` to check setup

### Build errors
- Run `flutter clean`
- Run `flutter pub get`
- Delete `build` folder and try again
