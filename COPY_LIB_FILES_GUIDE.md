# 📁 Copy Lib Files Guide - Easy Setup

This guide helps you easily copy all required files from the `lib/` folder to set up CurveFitPro.

---

## 📋 Complete File List

### ✅ All Files You Need to Copy

Copy the entire `lib/` folder structure as shown below:

```
lib/
├── main.dart                          ✅ REQUIRED - App entry point
├── screens/                            ✅ REQUIRED - All screen files
│   ├── curve_fitting_page.dart        ✅ REQUIRED - Main calculator
│   ├── settings_page.dart             ✅ REQUIRED - Settings screen
│   ├── about_page.dart                ✅ REQUIRED - About page
│   └── history_page.dart              ✅ REQUIRED - History screen
├── utils/                              ✅ REQUIRED - All utility files
│   ├── math_utils.dart                ✅ REQUIRED - Math calculations
│   ├── elimination_utils.dart         ✅ REQUIRED - Elimination method
│   ├── export_utils.dart              ✅ REQUIRED - PDF export
│   ├── format_utils.dart              ✅ REQUIRED - Data formatting
│   └── preferences_service.dart       ✅ REQUIRED - Settings storage
└── widgets/                            ✅ REQUIRED - All widget files
    ├── modern_table_widget.dart       ✅ REQUIRED - Data table
    ├── result_box_widget.dart         ✅ REQUIRED - Result display
    ├── elimination_steps_widget.dart  ✅ REQUIRED - Step-by-step display
    ├── equation_box.dart              ✅ REQUIRED - Equation display
    └── color_picker_widget.dart       ✅ REQUIRED - Color picker
```

---

## 🚀 Quick Copy Commands

### Option 1: Use Provided Scripts (Easiest)

**Windows:**
```cmd
# Double-click or run:
github\COPY_LIB_FILES.bat
```

**Linux/macOS:**
```bash
# Make executable and run:
chmod +x github/COPY_LIB_FILES.sh
./github/COPY_LIB_FILES.sh
```

### Option 2: Copy Entire lib Folder (Recommended)

```bash
# Copy entire lib folder
cp -r lib/ /path/to/your/project/
```

**Windows (PowerShell):**
```powershell
Copy-Item -Path lib -Destination /path/to/your/project/ -Recurse
```

**Windows (Command Prompt):**
```cmd
xcopy lib\ /path/to/your/project\lib\ /E /I
```

### Option 2: Copy Individual Files

If you need to copy files individually:

```bash
# Main file
cp lib/main.dart your-project/lib/

# Screens
cp lib/screens/*.dart your-project/lib/screens/

# Utils
cp lib/utils/*.dart your-project/lib/utils/

# Widgets
cp lib/widgets/*.dart your-project/lib/widgets/
```

---

## 📝 File Descriptions

### Main Entry Point

#### `lib/main.dart` (150 lines)
**Purpose**: App entry point, theme management, navigation  
**Required**: ✅ YES  
**What it does**:
- Initializes Flutter app
- Manages theme (light/dark)
- Handles navigation between screens
- Loads saved preferences

---

### Screens (4 files)

#### `lib/screens/curve_fitting_page.dart` (~1216 lines)
**Purpose**: Main calculation interface  
**Required**: ✅ YES  
**What it does**:
- Data input handling
- Curve type selection
- Calculation execution
- Results display
- PDF export

#### `lib/screens/settings_page.dart`
**Purpose**: App settings and customization  
**Required**: ✅ YES  
**What it does**:
- Theme toggle (light/dark)
- Color picker
- Settings management

#### `lib/screens/about_page.dart`
**Purpose**: App information and credits  
**Required**: ✅ YES  
**What it does**:
- Displays app version
- Shows developer information
- Links to resources

#### `lib/screens/history_page.dart`
**Purpose**: Calculation history management  
**Required**: ✅ YES  
**What it does**:
- Saves calculation history
- Displays past results
- History management

---

### Utilities (5 files)

#### `lib/utils/math_utils.dart` (96 lines)
**Purpose**: Mathematical calculation functions  
**Required**: ✅ YES  
**What it does**:
- Sum calculations (Σx, Σy, Σx², Σxy)
- Power calculations (xⁿ)
- Logarithmic transformations
- Validation functions

#### `lib/utils/elimination_utils.dart` (297 lines)
**Purpose**: Gaussian elimination method  
**Required**: ✅ YES  
**What it does**:
- Solves 2x2 systems
- Solves 3x3 systems
- Step-by-step tracking
- Detailed solution display

#### `lib/utils/export_utils.dart` (~889 lines)
**Purpose**: PDF document generation  
**Required**: ✅ YES  
**What it does**:
- Creates PDF documents
- Formats calculation results
- Saves to device
- Platform-specific handling

#### `lib/utils/format_utils.dart` (161 lines)
**Purpose**: Data formatting utilities  
**Required**: ✅ YES  
**What it does**:
- Number formatting
- Equation building
- Display formatting

#### `lib/utils/preferences_service.dart` (68 lines)
**Purpose**: Settings persistence  
**Required**: ✅ YES  
**What it does**:
- Saves theme preferences
- Saves color preferences
- Loads saved settings

---

### Widgets (5 files)

#### `lib/widgets/modern_table_widget.dart`
**Purpose**: Data table display  
**Required**: ✅ YES  
**What it does**:
- Displays calculation tables
- Scrollable content
- Responsive design

#### `lib/widgets/result_box_widget.dart`
**Purpose**: Result display  
**Required**: ✅ YES  
**What it does**:
- Shows final equation
- Displays results
- Copy functionality

#### `lib/widgets/elimination_steps_widget.dart` (~1110 lines)
**Purpose**: Step-by-step solution display  
**Required**: ✅ YES  
**What it does**:
- Shows elimination steps
- Expandable sections
- Equation formatting

#### `lib/widgets/equation_box.dart`
**Purpose**: Equation display  
**Required**: ✅ YES  
**What it does**:
- Formats equations
- Displays mathematical expressions

#### `lib/widgets/color_picker_widget.dart`
**Purpose**: Color selection  
**Required**: ✅ YES  
**What it does**:
- Color picker interface
- Theme customization
- Color preview

---

## 📦 Complete Copy Checklist

Use this checklist to ensure you have all files:

### Main Files
- [ ] `lib/main.dart`

### Screens (4 files)
- [ ] `lib/screens/curve_fitting_page.dart`
- [ ] `lib/screens/settings_page.dart`
- [ ] `lib/screens/about_page.dart`
- [ ] `lib/screens/history_page.dart`

### Utils (5 files)
- [ ] `lib/utils/math_utils.dart`
- [ ] `lib/utils/elimination_utils.dart`
- [ ] `lib/utils/export_utils.dart`
- [ ] `lib/utils/format_utils.dart`
- [ ] `lib/utils/preferences_service.dart`

### Widgets (5 files)
- [ ] `lib/widgets/modern_table_widget.dart`
- [ ] `lib/widgets/result_box_widget.dart`
- [ ] `lib/widgets/elimination_steps_widget.dart`
- [ ] `lib/widgets/equation_box.dart`
- [ ] `lib/widgets/color_picker_widget.dart`

**Total**: 15 files (all required)

---

## 🔧 Setup After Copying

### Step 1: Verify File Structure

After copying, your project should have:

```
your-project/
└── lib/
    ├── main.dart
    ├── screens/
    │   ├── curve_fitting_page.dart
    │   ├── settings_page.dart
    │   ├── about_page.dart
    │   └── history_page.dart
    ├── utils/
    │   ├── math_utils.dart
    │   ├── elimination_utils.dart
    │   ├── export_utils.dart
    │   ├── format_utils.dart
    │   └── preferences_service.dart
    └── widgets/
        ├── modern_table_widget.dart
        ├── result_box_widget.dart
        ├── elimination_steps_widget.dart
        ├── equation_box.dart
        └── color_picker_widget.dart
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Verify Imports

All files should import correctly. Check for any import errors:

```bash
flutter analyze
```

### Step 4: Run the App

```bash
flutter run
```

---

## 📊 File Size Reference

| File | Size | Lines | Priority |
|------|------|-------|----------|
| `main.dart` | 4.0 KB | 150 | ⭐⭐⭐ Critical |
| `curve_fitting_page.dart` | ~50 KB | ~1216 | ⭐⭐⭐ Critical |
| `elimination_steps_widget.dart` | ~45 KB | ~1110 | ⭐⭐⭐ Critical |
| `export_utils.dart` | ~35 KB | ~889 | ⭐⭐⭐ Critical |
| `elimination_utils.dart` | ~12 KB | 297 | ⭐⭐⭐ Critical |
| `format_utils.dart` | ~6 KB | 161 | ⭐⭐ Important |
| `math_utils.dart` | ~4 KB | 96 | ⭐⭐⭐ Critical |
| `preferences_service.dart` | ~3 KB | 68 | ⭐⭐ Important |
| Other widgets | ~2-5 KB each | 50-200 | ⭐⭐ Important |

---

## ⚠️ Important Notes

### Files NOT to Copy

These are backup/development files:
- ❌ `lib/main_backup.dart` - Backup file (not needed)
- ❌ `lib/main_new.dart` - Development file (not needed)

### Required Dependencies

After copying files, ensure these dependencies in `pubspec.yaml`:

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

---

## 🎯 Quick Start for New Users

### For Complete Beginners

1. **Download the project** from GitHub
2. **Copy the entire `lib/` folder** to your Flutter project
3. **Run** `flutter pub get`
4. **Run** `flutter run`

That's it! All files are ready to use.

### For Experienced Developers

1. Copy only the files you need
2. Adjust imports if needed
3. Customize as required

---

## 🔍 Verify Your Copy

After copying, run this command to verify:

```bash
# Count Dart files
find lib -name "*.dart" | wc -l

# Should show: 15 files
```

Or check manually:
```bash
# List all files
find lib -name "*.dart"
```

---

## 📚 Related Documentation

- [Android Studio Setup Guide](ANDROID_STUDIO_SETUP.md)
- [Complete Code Documentation](CODE_DOCUMENTATION.md)
- [Flutter Code Explanation](FLUTTER_CODE_EXPLANATION.md)
- [Dependencies Guide](DEPENDENCIES.md)

---

## ✅ Summary

**Total Files to Copy**: 15 files  
**Total Size**: ~200 KB  
**All Required**: ✅ YES  

**Quick Command**:
```bash
cp -r lib/ your-project/
```

---

<div align="center">

**Easy File Copy Guide**  
**CurveFitPro Project**

**Made with ❤️ by [Om Patel](https://omlalitpatel.netlify.app)**

</div>

