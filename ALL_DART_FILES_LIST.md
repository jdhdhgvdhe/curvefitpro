# 📋 Complete List of All Dart Files

This document lists all Dart source code files in the CurveFitPro project.

---

## 📁 File Structure

### Main Entry Point
- `lib/main.dart` (150 lines)
  - App entry point
  - Theme management
  - Navigation structure

### Screens (4 files)
- `lib/screens/curve_fitting_page.dart` (~1216 lines)
  - Main calculation interface
  - Data input handling
  - Curve fitting calculations
  - Results display

- `lib/screens/settings_page.dart`
  - Theme customization
  - Color picker
  - Settings management

- `lib/screens/about_page.dart`
  - App information
  - Developer credits
  - Version details

- `lib/screens/history_page.dart`
  - Calculation history
  - Saved results
  - History management

### Utilities (5 files)
- `lib/utils/math_utils.dart` (96 lines)
  - Mathematical calculations
  - Sum functions
  - Power functions
  - Logarithmic transforms

- `lib/utils/elimination_utils.dart` (297 lines)
  - Gaussian elimination
  - 2x2 system solver
  - 3x3 system solver
  - Step-by-step tracking

- `lib/utils/export_utils.dart` (~889 lines)
  - PDF generation
  - Document formatting
  - File saving
  - Platform handling

- `lib/utils/format_utils.dart` (161 lines)
  - Number formatting
  - Equation building
  - Data formatting

- `lib/utils/preferences_service.dart` (68 lines)
  - Settings persistence
  - Theme storage
  - Color storage

### Widgets (5 files)
- `lib/widgets/modern_table_widget.dart`
  - Data table display
  - Scrollable tables
  - Responsive design

- `lib/widgets/result_box_widget.dart`
  - Result display
  - Equation formatting
  - Copy functionality

- `lib/widgets/elimination_steps_widget.dart` (~1110 lines)
  - Step-by-step display
  - Expandable steps
  - Equation rendering

- `lib/widgets/equation_box.dart`
  - Equation display
  - Mathematical formatting

- `lib/widgets/color_picker_widget.dart`
  - Color selection
  - Theme customization
  - Color preview

---

## 📊 Statistics

- **Total Dart Files**: 15+
- **Total Lines of Code**: ~3000+
- **Main Files**: 1
- **Screen Files**: 4
- **Utility Files**: 5
- **Widget Files**: 5

---

## 🔍 File Details

### Largest Files
1. `elimination_steps_widget.dart` - ~1110 lines
2. `curve_fitting_page.dart` - ~1216 lines
3. `export_utils.dart` - ~889 lines
4. `elimination_utils.dart` - 297 lines
5. `format_utils.dart` - 161 lines

### Core Functionality Files
- **Math Calculations**: `math_utils.dart`
- **Elimination Method**: `elimination_utils.dart`
- **PDF Export**: `export_utils.dart`
- **Main App**: `main.dart`
- **Calculator**: `curve_fitting_page.dart`

---

## 📝 All Files for GitHub

When uploading to GitHub, ensure all these files are included:

```
lib/
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

## ✅ Verification

To verify all files are present:

```bash
# Count Dart files
find lib -name "*.dart" | wc -l

# List all files
find lib -name "*.dart"
```

---

<div align="center">

**Complete Dart Files List**  
**CurveFitPro Project**

</div>

