# 📊 CurveFitPro - Advanced Curve Fitting Calculator

<div align="center">

![CurveFitPro Logo](https://img.shields.io/badge/CurveFitPro-Mathematical%20Calculator-purple?style=for-the-badge)
![Flutter](https://img.shields.io/badge/Flutter-3.9.2-blue?style=for-the-badge&logo=flutter)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Web%20%7C%20Windows-lightgrey?style=for-the-badge)

**A powerful mathematical curve fitting application built with Flutter**

[🌐 Live Website](https://curvefitting.netlify.app) • [📱 Download APK](#-download) • [💻 Source Code](hhttps://github.com/jdhdhgvdhe/curvefitpro/tree/main/lib) • [👨‍💻 Developer](https://omlalitpatel.netlify.app)

</div>

---

## 📖 About

CurveFitPro is a comprehensive mathematical curve fitting calculator designed to help students and engineers easily perform and visualize different types of curve fitting methods. The app supports **Straight Line**, **Quadratic Parabola**, and **Exponential** curve fitting using the **Least Squares Method** with detailed step-by-step solutions.

### ✨ Key Features

- 🔢 **Multiple Curve Types**: Support for Linear, Quadratic, and Exponential curve fitting
- 📊 **Step-by-Step Solutions**: Detailed elimination method with visual representation
- 📄 **PDF Export**: Export complete calculations to professional PDF documents
- 🎨 **Customizable Themes**: Dark/Light mode with customizable color schemes
- 📱 **Multi-Platform**: Works on Android, Web, and Windows
- 💾 **Offline Support**: Full functionality without internet connection (mobile app)
- 🔒 **Privacy-Focused**: No data collection, all calculations performed locally
- 🆓 **Completely Free**: No ads, no hidden charges

---

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart SDK (included with Flutter)
- Android Studio / VS Code with Flutter extensions
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/jdhdhgvdhe/curvefitpro.git
   cd curvefitpro
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For Android
   flutter run
   
   # For Web
   flutter run -d chrome
   
   # For Windows
   flutter run -d windows
   ```

### 📱 Download APK

Download the latest Android APK directly:

- **Latest Release**: [CurveFitPro.apk](https://github.com/jdhdhgvdhe/curvefitpro/raw/refs/heads/main/downloads/CurveFitPro.apk)


> ⚠️ **Note**: If you see security warnings during installation, please refer to the [Installation Guide](https://curvefitting.netlify.app/INSTALLATION_GUIDE.html)

---

## 🛠️ Technology Stack

### Frontend Framework
- **Flutter 3.9.2**: Cross-platform UI framework
- **Dart**: Programming language

### Key Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `google_fonts` | ^6.1.0 | Beautiful typography |
| `pdf` | ^3.10.7 | PDF document generation |
| `printing` | ^5.11.1 | PDF printing and sharing |
| `path_provider` | ^2.1.5 | File system access |
| `permission_handler` | ^11.3.1 | Android permissions |
| `url_launcher` | ^6.2.2 | External URL handling |
| `shared_preferences` | ^2.2.2 | Local data storage |
| `share_plus` | ^10.1.3 | Content sharing |
| `flutter_math_fork` | ^0.7.2 | Mathematical expressions rendering |

### Development Tools
- **flutter_lints**: ^5.0.0 - Code quality and linting
- **flutter_launcher_icons**: ^0.14.2 - App icon generation

---

## 📁 Project Structure

```
curvefitpro/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── screens/                  # UI screens
│   │   ├── curve_fitting_page.dart
│   │   ├── settings_page.dart
│   │   ├── about_page.dart
│   │   └── history_page.dart
│   ├── utils/                     # Utility functions
│   │   ├── math_utils.dart       # Mathematical calculations
│   │   ├── elimination_utils.dart # Step-by-step elimination
│   │   ├── export_utils.dart     # PDF export functionality
│   │   ├── format_utils.dart     # Data formatting
│   │   └── preferences_service.dart # Settings persistence
│   └── widgets/                   # Reusable widgets
│       ├── modern_table_widget.dart
│       ├── result_box_widget.dart
│       ├── elimination_steps_widget.dart
│       ├── equation_box.dart
│       └── color_picker_widget.dart
├── android/                       # Android-specific code
├── web/                          # Web-specific code
├── windows/                      # Windows-specific code
├── website/                      # Marketing website
├── pubspec.yaml                  # Dependencies configuration
└── README.md                     # This file
```

---

## 🧮 Mathematical Methods

### Supported Curve Types

1. **Straight Line (Linear)**: `y = ax + b`
   - Uses least squares method
   - Calculates slope (a) and intercept (b)

2. **Quadratic Parabola**: `y = ax² + bx + c`
   - Second-degree polynomial fitting
   - Calculates coefficients a, b, and c

3. **Exponential Curve**: `y = ae^(bx)`
   - Exponential regression
   - Linearizes using natural logarithm

### Calculation Process

1. **Data Input**: User enters X and Y data points
2. **Summation**: Calculate Σx, Σy, Σxy, Σx², etc.
3. **Normal Equations**: Form system of equations
4. **Gaussian Elimination**: Solve using elimination method
5. **Step-by-Step Display**: Show each calculation step
6. **Result Display**: Final equation and coefficients

---

## 📚 Documentation

- 📖 [Complete Code Documentation](CODE_DOCUMENTATION.md)
- 📄 [Flutter Code Explanation](FLUTTER_CODE_EXPLANATION.md)
- 🔧 [Android Studio Setup Guide](ANDROID_STUDIO_SETUP.md)
- 📦 [Dependencies Documentation](DEPENDENCIES.md)
- 🌐 [Website Code Documentation](WEBSITE_CODE_DOCUMENTATION.md)
- 📋 [All Dart Files List](ALL_DART_FILES_LIST.md)
- 📄 [Generate PDF Guide](GENERATE_DART_CODE_PDF.md)
- 📁 [Copy Lib Files Guide](COPY_LIB_FILES_GUIDE.md) - **Easy file copying**
- ⚡ [Quick Start Guide](QUICK_START.md) - **Fastest setup**
- ✅ [Required Files Checklist](REQUIRED_FILES_CHECKLIST.md) - **Verify all files**

---

## 🧪 Testing

Run tests using:

```bash
flutter test
```

Test files:
- `test/elimination_test.dart` - Mathematical calculations tests
- `test/widget_test.dart` - Widget functionality tests

---

## 📦 Building for Production

### Android APK

```bash
# Build release APK
flutter build apk --release

# Build app bundle (for Play Store)
flutter build appbundle --release
```

### Web

```bash
# Build for web
flutter build web --release

# Output will be in build/web/
```

### Windows

```bash
# Build for Windows
flutter build windows --release
```

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines

- Follow Flutter/Dart style guidelines
- Write meaningful commit messages
- Add tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Development Team

### Lead Developer
- **Om Patel** - [Portfolio](https://omlalitpatel.netlify.app) | [GitHub](https://github.com/jdhdhgvdhe)

### Team Members
- Om Bhoi
- Kiratan Thakkar
- Harsh Parmar
- Chirayu Choksi
- Makvana Nikhil

### Guidance
- **Miral Darji** - Project Guide

---

## 🌐 Links

- 🌐 **Live Website**: [curvefitting.netlify.app](https://curvefitting.netlify.app)
- 📱 **Web App**: [Launch App](https://curvefitpro.netlify.app)
- 💻 **GitHub Repository**: [github.com/jdhdhgvdhe/curvefitpro](https://github.com/jdhdhgvdhe/curvefitpro)
- 👨‍💻 **Developer Portfolio**: [omlalitpatel.netlify.app](https://omlalitpatel.netlify.app)
- 📄 **Installation Guide**: [Installation Instructions](https://curvefitting.netlify.app/INSTALLATION_GUIDE.html)
- 🔒 **Privacy Policy**: [Privacy Policy](https://curvefitting.netlify.app/privacy-policy.html)
- 📋 **Terms of Service**: [Terms of Service](https://curvefitting.netlify.app/terms-of-service.html)

---

## 📊 Project Statistics

- **Lines of Code**: ~5000+
- **Dependencies**: 9 main packages
- **Platforms**: Android, Web, Windows
- **Languages**: Dart, HTML, CSS, JavaScript
- **License**: MIT

---

## 🐛 Known Issues

- None currently reported. Please open an issue if you find any bugs.

---

## 🗺️ Roadmap

- [ ] iOS support
- [ ] Additional curve types (Logarithmic, Power)
- [ ] Graph visualization
- [ ] Data import from CSV/Excel
- [ ] Cloud sync (optional)
- [ ] Multi-language support

---

## 💬 Support

For support, please:
1. Check the [Installation Guide](https://curvefitting.netlify.app/INSTALLATION_GUIDE.html)
2. Open an issue on [GitHub](https://github.com/jdhdhgvdhe/curvefitpro/issues)
3. Contact the developer via [Portfolio](https://omlalitpatel.netlify.app)

---

## ⭐ Show Your Support

If you find this project helpful, please consider giving it a ⭐ on GitHub!

---

<div align="center">

**Made with ❤️ by Om Patel and Team**

[⬆ Back to Top](#-curvefitpro---advanced-curve-fitting-calculator)

</div>
