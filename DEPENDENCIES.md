# 📦 Dependencies Documentation

This document explains all dependencies used in CurveFitPro, why they are needed, and how they are used.

## Core Dependencies

### 1. `flutter` (SDK)
- **Version**: 3.9.2
- **Purpose**: Core Flutter framework
- **Why**: Provides the cross-platform UI framework for building Android, Web, and Windows apps
- **Usage**: Base framework for all UI components and app structure

### 2. `cupertino_icons` ^1.0.8
- **Purpose**: iOS-style icons
- **Why**: Provides Material Design icons and Cupertino icons for consistent UI
- **Usage**: Used throughout the app for buttons, navigation, and UI elements

---

## UI & Design Dependencies

### 3. `google_fonts` ^6.1.0
- **Purpose**: Beautiful typography
- **Why**: Provides access to Google Fonts library for professional typography
- **Usage**: 
  - Used in `main.dart` for app-wide font styling
  - Provides Poppins, Roboto, and other modern fonts
  - Enhances readability and visual appeal
- **Code Example**:
  ```dart
  import 'package:google_fonts/google_fonts.dart';
  GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16))
  ```

### 4. `flutter_math_fork` ^0.7.2
- **Purpose**: Mathematical expressions rendering
- **Why**: Displays complex mathematical equations in a readable format
- **Usage**: 
  - Renders equations like `y = ax + b` with proper formatting
  - Used in result displays and step-by-step solutions
  - Supports LaTeX-like syntax for mathematical notation

---

## File & Document Management

### 5. `pdf` ^3.10.7
- **Purpose**: PDF document generation
- **Why**: Creates professional PDF documents for exporting calculations
- **Usage**: 
  - Used in `export_utils.dart` for generating PDF reports
  - Creates formatted documents with tables, equations, and step-by-step solutions
  - Supports custom styling and layouts
- **Key Features**:
  - Multi-page documents
  - Custom fonts and colors
  - Tables and formatted text
  - Mathematical equations

### 6. `printing` ^5.11.1
- **Purpose**: PDF printing and sharing
- **Why**: Allows users to print or share generated PDFs
- **Usage**: 
  - Works with `pdf` package to print documents
  - Provides sharing functionality (email, cloud storage, etc.)
  - Cross-platform printing support
- **Code Example**:
  ```dart
  await Printing.layoutPdf(
    onLayout: (format) => pdf.save(),
  );
  ```

### 7. `path_provider` ^2.1.5
- **Purpose**: File system access
- **Why**: Provides paths to app directories for saving files
- **Usage**: 
  - Gets application documents directory
  - Used for saving PDF files locally
  - Platform-specific path handling
- **Code Example**:
  ```dart
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/calculation.pdf');
  ```

---

## Permissions & System Integration

### 8. `permission_handler` ^11.3.1
- **Purpose**: Android permissions management
- **Why**: Handles runtime permissions for file access
- **Usage**: 
  - Requests storage permission for saving PDFs
  - Checks permission status before file operations
  - Handles permission denial gracefully
- **Permissions Used**:
  - `Storage`: For saving PDF files
  - `Internet`: Optional, for web features

### 9. `url_launcher` ^6.2.2
- **Purpose**: External URL handling
- **Why**: Opens URLs in browser (e.g., documentation, support links)
- **Usage**: 
  - Opens external links from the app
  - Launches email clients
  - Opens web pages in default browser

---

## Data Persistence

### 10. `shared_preferences` ^2.2.2
- **Purpose**: Local data storage
- **Why**: Stores user preferences and settings
- **Usage**: 
  - Saves theme mode (dark/light)
  - Stores primary color preference
  - Persists user settings across app restarts
- **Code Example**:
  ```dart
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('theme_mode', 'dark');
  ```

---

## Sharing & Communication

### 11. `share_plus` ^10.1.3
- **Purpose**: Content sharing
- **Why**: Allows users to share results and PDFs
- **Usage**: 
  - Share PDF files via other apps
  - Share calculation results
  - Cross-platform sharing support
- **Code Example**:
  ```dart
  await Share.shareXFiles([XFile(filePath)]);
  ```

---

## Development Dependencies

### 12. `flutter_test` (SDK)
- **Purpose**: Unit and widget testing
- **Why**: Provides testing framework for Flutter apps
- **Usage**: 
  - Unit tests for mathematical functions
  - Widget tests for UI components
  - Integration tests

### 13. `flutter_lints` ^5.0.0
- **Purpose**: Code quality and linting
- **Why**: Enforces Dart/Flutter coding standards
- **Usage**: 
  - Static code analysis
  - Style guide enforcement
  - Error detection
- **Configuration**: `analysis_options.yaml`

### 14. `flutter_launcher_icons` ^0.14.2
- **Purpose**: App icon generation
- **Why**: Automatically generates app icons for all platforms
- **Usage**: 
  - Generates Android icons
  - Creates web favicons
  - Windows icon generation
- **Configuration**: `pubspec.yaml` → `flutter_launcher_icons`

---

## Dependency Tree

```
curvefitpro
├── flutter (SDK)
├── cupertino_icons ^1.0.8
├── google_fonts ^6.1.0
├── flutter_math_fork ^0.7.2
├── pdf ^3.10.7
│   └── (internal dependencies)
├── printing ^5.11.1
│   └── pdf ^3.10.7
├── path_provider ^2.1.5
│   └── (platform-specific implementations)
├── permission_handler ^11.3.1
│   └── (platform-specific implementations)
├── url_launcher ^6.2.2
│   └── (platform-specific implementations)
├── shared_preferences ^2.2.2
│   └── (platform-specific implementations)
└── share_plus ^10.1.3
    └── (platform-specific implementations)
```

---

## Why These Dependencies?

### Design Philosophy

1. **Minimal Dependencies**: Only essential packages are included
2. **Well-Maintained**: All packages are actively maintained
3. **Cross-Platform**: All dependencies support Android, Web, and Windows
4. **Performance**: Lightweight packages that don't bloat the app
5. **Privacy**: No analytics or tracking dependencies

### Alternatives Considered

- **PDF Generation**: Considered `pdfx` but `pdf` is more mature
- **Fonts**: Could use system fonts, but Google Fonts provides better design
- **Storage**: Could use SQLite, but SharedPreferences is simpler for settings
- **Sharing**: Native sharing is limited, `share_plus` provides better UX

---

## Version Management

All dependencies use **caret (^) versioning**:
- `^6.1.0` means `>=6.1.0 <7.0.0`
- Allows patch and minor updates
- Prevents breaking changes

### Updating Dependencies

```bash
# Check for updates
flutter pub outdated

# Update to latest compatible versions
flutter pub upgrade

# Update specific package
flutter pub upgrade google_fonts
```

---

## Security Considerations

- All dependencies are from official pub.dev
- Regular security audits via `flutter pub audit`
- No dependencies with known vulnerabilities
- All packages are open-source and auditable

---

## License Compatibility

All dependencies are compatible with MIT License:
- `google_fonts`: Apache 2.0 / OFL
- `pdf`: BSD-3-Clause
- `printing`: Apache 2.0
- `shared_preferences`: BSD-3-Clause
- All other packages: MIT or compatible licenses

---

## Performance Impact

| Package | Size Impact | Performance Impact |
|---------|-------------|-------------------|
| `google_fonts` | ~2MB | Minimal (fonts cached) |
| `pdf` | ~500KB | Only when generating PDFs |
| `printing` | ~300KB | Only when printing |
| `flutter_math_fork` | ~200KB | Minimal (rendering only) |
| Others | <100KB each | Negligible |

**Total Impact**: ~4MB additional app size, minimal runtime performance impact.

---

## Future Considerations

Potential additions:
- `charts_flutter`: For graph visualization (future feature)
- `csv`: For data import (future feature)
- `http`: For optional cloud sync (future feature)

These are not currently included to keep the app lightweight and privacy-focused.

