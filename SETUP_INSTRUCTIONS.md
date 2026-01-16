# Flutter Setup Instructions for Windows

## Step 1: Install Flutter

### Option A: Using Git (Recommended)

1. **Download Flutter SDK:**
   - Go to https://docs.flutter.dev/get-started/install/windows
   - Download the latest Flutter SDK zip file
   - Extract it to a location like `C:\src\flutter` (avoid spaces in path)

2. **Add Flutter to PATH:**
   - Press `Win + X` and select "System"
   - Click "Advanced system settings"
   - Click "Environment Variables"
   - Under "User variables", find "Path" and click "Edit"
   - Click "New" and add: `C:\src\flutter\bin` (or your Flutter installation path)
   - Click "OK" on all dialogs

3. **Restart your terminal/PowerShell**

### Option B: Using Chocolatey (Easier)

If you have Chocolatey installed:
```powershell
choco install flutter
```

### Option C: Using Scoop

If you have Scoop installed:
```powershell
scoop install flutter
```

## Step 2: Verify Installation

Open a new PowerShell window and run:
```powershell
flutter doctor
```

This will check your setup and show what's missing.

## Step 3: Install Required Dependencies

Flutter doctor will tell you what's missing. Typically you need:

1. **Android Studio:**
   - Download from https://developer.android.com/studio
   - Install Android Studio
   - Open it and go through the setup wizard
   - Install Android SDK, Android SDK Platform, and Android Virtual Device

2. **VS Code (Optional but recommended):**
   - Download from https://code.visualstudio.com/
   - Install Flutter extension from VS Code marketplace

3. **For iOS development (Mac only):**
   - Xcode (only available on macOS)

## Step 4: Accept Android Licenses

After installing Android Studio, run:
```powershell
flutter doctor --android-licenses
```

Accept all licenses by typing `y` when prompted.

## Step 5: Set Up Your Project

Once Flutter is installed:

1. Navigate to your project:
   ```powershell
   cd D:\CursorProjects\NewMovieApp
   ```

2. Get dependencies:
   ```powershell
   flutter pub get
   ```

3. Check if everything is ready:
   ```powershell
   flutter doctor
   ```

4. List available devices:
   ```powershell
   flutter devices
   ```

5. Run the app:
   ```powershell
   flutter run
   ```

## Quick Check Commands

```powershell
# Check Flutter version
flutter --version

# Check available devices
flutter devices

# Run the app
flutter run

# Build for Android
flutter build apk

# Build for iOS (Mac only)
flutter build ios
```

## Troubleshooting

### Flutter command not found
- Make sure you added Flutter to PATH
- Restart your terminal/PowerShell
- Try using the full path: `C:\src\flutter\bin\flutter.bat`

### Android Studio not detected
- Make sure Android Studio is installed
- Set ANDROID_HOME environment variable to your Android SDK path
- Usually: `C:\Users\YourUsername\AppData\Local\Android\Sdk`

### No devices found
- For Android: Start an emulator from Android Studio or connect a physical device
- For iOS: Only available on Mac with Xcode

## Need Help?

- Flutter Documentation: https://docs.flutter.dev/
- Flutter Community: https://flutter.dev/community
