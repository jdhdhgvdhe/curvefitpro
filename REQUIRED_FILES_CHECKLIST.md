# ✅ Required Files Checklist - Copy from lib/

Use this checklist to ensure you copy all required files from the `lib/` folder.

---

## 📋 Complete File List (15 Files Required)

### ✅ Main Entry Point (1 file)
- [x] `lib/main.dart` - **REQUIRED**

### ✅ Screens (4 files)
- [x] `lib/screens/curve_fitting_page.dart` - **REQUIRED**
- [x] `lib/screens/settings_page.dart` - **REQUIRED**
- [x] `lib/screens/about_page.dart` - **REQUIRED**
- [x] `lib/screens/history_page.dart` - **REQUIRED**

### ✅ Utils (5 files)
- [x] `lib/utils/math_utils.dart` - **REQUIRED**
- [x] `lib/utils/elimination_utils.dart` - **REQUIRED**
- [x] `lib/utils/export_utils.dart` - **REQUIRED**
- [x] `lib/utils/format_utils.dart` - **REQUIRED**
- [x] `lib/utils/preferences_service.dart` - **REQUIRED**

### ✅ Widgets (5 files)
- [x] `lib/widgets/modern_table_widget.dart` - **REQUIRED**
- [x] `lib/widgets/result_box_widget.dart` - **REQUIRED**
- [x] `lib/widgets/elimination_steps_widget.dart` - **REQUIRED**
- [x] `lib/widgets/equation_box.dart` - **REQUIRED**
- [x] `lib/widgets/color_picker_widget.dart` - **REQUIRED**

---

## ❌ Files NOT to Copy (Backup/Development)

- ❌ `lib/main_backup.dart` - Backup file (not needed)
- ❌ `lib/main_new.dart` - Development file (not needed)

---

## 🚀 Quick Copy Command

### Copy All Required Files at Once

**Windows:**
```cmd
xcopy lib\main.dart your-project\lib\ /Y
xcopy lib\screens\*.dart your-project\lib\screens\ /Y
xcopy lib\utils\*.dart your-project\lib\utils\ /Y
xcopy lib\widgets\*.dart your-project\lib\widgets\ /Y
```

**Linux/macOS:**
```bash
cp lib/main.dart your-project/lib/
cp lib/screens/*.dart your-project/lib/screens/
cp lib/utils/*.dart your-project/lib/utils/
cp lib/widgets/*.dart your-project/lib/widgets/
```

**Or copy entire folder (excludes backup files):**
```bash
cp -r lib/ your-project/
# Then delete backup files manually
```

---

## 📊 File Count Verification

After copying, verify you have **15 files**:

```bash
# Count Dart files (should be 15)
find lib -name "*.dart" ! -name "*backup*" ! -name "*new*" | wc -l
```

---

## ✅ Verification Checklist

After copying, check:

- [ ] `lib/main.dart` exists
- [ ] `lib/screens/` has 4 files
- [ ] `lib/utils/` has 5 files
- [ ] `lib/widgets/` has 5 files
- [ ] Total: 15 files
- [ ] No backup files copied

---

## 🎯 Summary

**Total Required Files**: 15  
**Total to Skip**: 2 (backup files)  
**Quick Copy**: Use provided scripts or copy entire `lib/` folder

---

<div align="center">

**Required Files Checklist**  
**CurveFitPro**

</div>

