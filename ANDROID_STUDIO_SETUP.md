# 📱 Android Studio Setup Guide for CurveFitPro

Complete step-by-step guide to set up and build CurveFitPro in Android Studio.

---

## 📋 Prerequisites

### Required Software

1. **Android Studio** (Latest version)
   - Download: [developer.android.com/studio](https://developer.android.com/studio)
   - Minimum: Android Studio Hedgehog | 2023.1.1 or later

2. **Flutter SDK** (3.9.2 or higher)
   - Download: [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
   - Extract to a location (e.g., `C:\src\flutter` on Windows)

3. **Java Development Kit (JDK)**
   - JDK 17 or higher
   - Android Studio includes JDK, but you can install separately

4. **Git** (Optional but recommended)
   - Download: [git-scm.com/downloads](https://git-scm.com/downloads)

---

## 🚀 Step-by-Step Setup

### Step 1: Install Android Studio

1. Download Android Studio from the official website
2. Run the installer and follow the setup wizard
3. Select "Standard" installation
4. Wait for SDK components to download

### Step 2: Install Flutter Plugin

1. Open Android Studio
2. Go to **File → Settings** (Windows/Linux) or **Android Studio → Preferences** (Mac)
3. Navigate to **Plugins**
4. Search for "Flutter"
5. Click **Install** (Dart plugin will be installed automatically)
6. Restart Android Studio

### Step 3: Configure Flutter SDK

1. Go to **File → Settings → Languages & Frameworks → Flutter**
2. Click **Browse** next to "Flutter SDK path"
3. Navigate to your Flutter installation folder
4. Click **Apply** and **OK**

### Step 4: Verify Installation

1. Open terminal in Android Studio (**View → Tool Windows → Terminal**)
2. Run:
   ```bash
   flutter doctor
   ```
3. Ensure all checks pass (green checkmarks)

---

## 📥 Clone/Open Project

### Option 1: Clone from GitHub

```bash
git clone https://github.com/jdhdhgvdhe/curvefitpro.git
cd curvefitpro
```

### Option 2: Open Existing Project

1. Open Android Studio
2. Click **Open** or **File → Open**
3. Navigate to the `curvefit` folder
4. Select the folder and click **OK**

---

## 🔧 Project Configuration

### Step 1: Install Dependencies

1. Open terminal in Android Studio
2. Run:
   ```bash
   flutter pub get
   ```
3. Wait for dependencies to download

### Step 2: Verify Dependencies

Check `pubspec.yaml` for all required packages:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_math_fork: ^0.7.2
  google_fonts: ^6.1.0
  pdf: ^3.10.7
  printing: ^5.11.1
  path_provider: ^2.1.5
  permission_handler: ^11.3.1
  url_launcher: ^6.2.2
  shared_preferences: ^2.2.2
  share_plus: ^10.1.3
```

### Step 3: Configure Android SDK

1. Go to **File → Project Structure**
2. Under **SDK Location**, verify:
   - Android SDK location is set
   - JDK location is set
3. Click **OK**

---

## 📱 Setup Android Device/Emulator

### Option 1: Physical Device

1. Enable **Developer Options** on your Android device:
   - Go to **Settings → About Phone**
   - Tap **Build Number** 7 times
2. Enable **USB Debugging**:
   - Go to **Settings → Developer Options**
   - Enable **USB Debugging**
3. Connect device via USB
4. Accept USB debugging prompt on device
5. Verify connection:
   ```bash
   flutter devices
   ```

### Option 2: Android Emulator

1. Open **Tools → Device Manager**
2. Click **Create Device**
3. Select a device (e.g., Pixel 5)
4. Select system image (API 33 or higher recommended)
5. Click **Finish**
6. Start the emulator

---

## 🏗️ Build and Run

### Debug Build

1. Select device/emulator from dropdown
2. Click **Run** button (▶️) or press `Shift + F10`
3. Wait for build to complete
4. App will launch automatically

### Release Build (APK)

1. Open terminal
2. Run:
   ```bash
   flutter build apk --release
   ```
3. APK will be in: `build/app/outputs/flutter-apk/app-release.apk`

### App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

---

## 📦 Dependencies Explained

### Core Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter` | SDK | Core Flutter framework |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |
| `google_fonts` | ^6.1.0 | Beautiful typography |
| `flutter_math_fork` | ^0.7.2 | Mathematical expressions rendering |

### File & Document

| Package | Version | Purpose |
|---------|---------|---------|
| `pdf` | ^3.10.7 | PDF document generation |
| `printing` | ^5.11.1 | PDF printing and sharing |
| `path_provider` | ^2.1.5 | File system access |

### System Integration

| Package | Version | Purpose |
|---------|---------|---------|
| `permission_handler` | ^11.3.1 | Android permissions |
| `url_launcher` | ^6.2.2 | External URL handling |
| `shared_preferences` | ^2.2.2 | Local data storage |
| `share_plus` | ^10.1.3 | Content sharing |

---

## 🐛 Troubleshooting

### Issue: "Flutter SDK not found"

**Solution:**
1. Go to **File → Settings → Languages & Frameworks → Flutter**
2. Set Flutter SDK path correctly
3. Restart Android Studio

### Issue: "Gradle sync failed"

**Solution:**
1. Go to **File → Invalidate Caches → Invalidate and Restart**
2. Run `flutter clean` in terminal
3. Run `flutter pub get`
4. Sync project again

### Issue: "No devices found"

**Solution:**
1. Check USB debugging is enabled
2. Try different USB cable/port
3. Run `adb devices` to check connection
4. Restart ADB: `adb kill-server && adb start-server`

### Issue: "Build failed - dependencies"

**Solution:**
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### Issue: "Permission denied"

**Solution:**
1. Check `android/app/src/main/AndroidManifest.xml`
2. Ensure permissions are declared:
   ```xml
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
   ```

---

## 📝 Project Structure

```
curvefit/
├── android/              # Android-specific code
│   ├── app/
│   │   ├── build.gradle.kts
│   │   └── src/
│   └── build.gradle.kts
├── lib/                  # Dart source code
│   ├── main.dart
│   ├── screens/
│   ├── utils/
│   └── widgets/
├── pubspec.yaml          # Dependencies
└── README.md
```

---

## 🔑 Key Files

### `pubspec.yaml`
- Contains all dependencies
- Defines app metadata
- Asset configuration

### `android/app/build.gradle.kts`
- Android build configuration
- Version codes
- Signing configs

### `lib/main.dart`
- App entry point
- Main application widget

---

## ✅ Verification Checklist

- [ ] Android Studio installed
- [ ] Flutter plugin installed
- [ ] Flutter SDK configured
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Device/Emulator connected
- [ ] `flutter doctor` shows no errors
- [ ] Project builds successfully
- [ ] App runs on device/emulator

---

## 🚀 Quick Start Commands

```bash
# Check Flutter installation
flutter doctor

# Get dependencies
flutter pub get

# Run on connected device
flutter run

# Build release APK
flutter build apk --release

# Build app bundle
flutter build appbundle --release

# Clean build
flutter clean

# Check for updates
flutter upgrade
```

---

## 📚 Additional Resources

- **Flutter Documentation**: [flutter.dev/docs](https://flutter.dev/docs)
- **Android Studio Guide**: [developer.android.com/studio/intro](https://developer.android.com/studio/intro)
- **Dart Language**: [dart.dev/guides](https://dart.dev/guides)
- **Project GitHub**: [github.com/jdhdhgvdhe/curvefitpro](https://github.com/jdhdhgvdhe/curvefitpro)

---

## 💡 Tips

1. **Use Flutter DevTools** for debugging
2. **Enable Hot Reload** for faster development
3. **Use Git** for version control
4. **Regular Updates**: Keep Flutter and dependencies updated
5. **Test on Multiple Devices**: Ensure compatibility

---

## 🆘 Need Help?

- **GitHub Issues**: [github.com/jdhdhgvdhe/curvefitpro/issues](https://github.com/jdhdhgvdhe/curvefitpro/issues)
- **Developer Portfolio**: [omlalitpatel.netlify.app](https://omlalitpatel.netlify.app)
- **Flutter Community**: [flutter.dev/community](https://flutter.dev/community)

---

<div align="center">

**Happy Coding! 🚀**

Made with ❤️ by [Om Patel](https://omlalitpatel.netlify.app)

</div>

