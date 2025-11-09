# ⚡ Quick Start Guide - Copy Lib Files

The **fastest way** to get all required files from the `lib/` folder.

---

## 🎯 One-Command Copy

### Windows

```cmd
xcopy lib\ your-project\lib\ /E /I /Y
```

### Linux/macOS

```bash
cp -r lib/ your-project/
```

### PowerShell

```powershell
Copy-Item -Path lib -Destination your-project\ -Recurse
```

---

## 📋 What Gets Copied

✅ **15 Dart files** total:
- 1 main file
- 4 screen files
- 5 utility files
- 5 widget files

---

## ✅ After Copying

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run the app**:
   ```bash
   flutter run
   ```

---

## 📁 File Structure

After copying, you'll have:

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

---

## 🚀 That's It!

All files are ready. Just run `flutter pub get` and `flutter run`.

---

<div align="center">

**Quick Start Guide**  
**CurveFitPro**

</div>

