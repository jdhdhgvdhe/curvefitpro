# 📚 Complete Flutter Code Explanation

This document provides a comprehensive explanation of all Flutter/Dart code in the CurveFitPro application.

---

## Table of Contents

1. [Main Application Entry Point](#1-main-application-entry-point)
2. [Screens](#2-screens)
3. [Utility Classes](#3-utility-classes)
4. [Widgets](#4-widgets)
5. [Mathematical Algorithms](#5-mathematical-algorithms)
6. [Code Flow Diagrams](#6-code-flow-diagrams)

---

## 1. Main Application Entry Point

### File: `lib/main.dart`

#### Purpose
The main entry point of the Flutter application. Manages app-wide state, theme, navigation, and initialization.

#### Key Components

##### 1.1 Main Function
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CurveFittingApp());
}
```

**Explanation:**
- `WidgetsFlutterBinding.ensureInitialized()`: Prepares Flutter framework before running the app
- `runApp()`: Starts the Flutter application with the root widget

**Why it's needed:**
- Ensures proper initialization of Flutter services
- Required for async operations before app start

##### 1.2 CurveFittingApp Class
```dart
class CurveFittingApp extends StatefulWidget {
  const CurveFittingApp({super.key});
  
  @override
  State<CurveFittingApp> createState() => _CurveFittingAppState();
}
```

**Explanation:**
- `StatefulWidget`: Widget that can change over time
- Creates state object `_CurveFittingAppState` to manage app state

**State Variables:**
- `_themeMode`: Current theme (light/dark)
- `_primaryColor`: Primary color for UI
- `_currentIndex`: Current tab index
- `_isLoading`: Loading state while settings load

##### 1.3 Settings Loading
```dart
Future<void> _loadSettings() async {
  final themeMode = await PreferencesService.loadThemeMode();
  final primaryColor = await PreferencesService.loadPrimaryColor();
  
  setState(() {
    _themeMode = themeMode;
    _primaryColor = primaryColor;
    _isLoading = false;
  });
}
```

**Explanation:**
- Loads saved user preferences from SharedPreferences
- Sets app theme and color based on saved values
- Updates UI when loading completes

**Why async:**
- SharedPreferences operations are asynchronous
- Prevents blocking UI thread

##### 1.4 Theme Management
```dart
void _toggleTheme(ThemeMode mode) async {
  setState(() {
    _themeMode = mode;
  });
  await PreferencesService.saveThemeMode(mode);
}
```

**Explanation:**
- Toggles between light and dark themes
- Saves preference for next app launch
- Updates UI immediately with `setState()`

##### 1.5 Navigation Structure
```dart
final List<Widget> pages = [
  CurveFittingPage(...),
  SettingsPage(...),
  const AboutPage(),
];
```

**Explanation:**
- Three main screens: Calculator, Settings, About
- Uses `IndexedStack` to maintain state across tabs
- Bottom navigation bar for switching

**Why IndexedStack:**
- Preserves state when switching tabs
- Better performance than rebuilding widgets

---

## 2. Screens

### 2.1 Curve Fitting Page (`lib/screens/curve_fitting_page.dart`)

#### Purpose
Main calculation interface where users input data and perform curve fitting.

#### Key Components

##### 2.1.1 State Variables
```dart
List<double> xValues = [];
List<double> yValues = [];
List<List<String>> tableData = [];
List<Map<String, dynamic>> eliminationSteps = [];
String finalEquation = "";
```

**Explanation:**
- `xValues`, `yValues`: Input data points
- `tableData`: Formatted table for display
- `eliminationSteps`: Step-by-step solution
- `finalEquation`: Final fitted equation

##### 2.1.2 Input Parsing
```dart
List<double> parseInput(String input) {
  return input
    .split(RegExp(r'[,\s]+'))
    .where((e) => e.trim().isNotEmpty)
    .map((e) => double.tryParse(e.trim()))
    .where((e) => e != null)
    .toList();
}
```

**Explanation:**
- Splits input by commas or spaces
- Filters empty strings
- Parses each value to double
- Returns list of valid numbers

**Why this approach:**
- Flexible input format (comma or space separated)
- Handles various user input styles
- Validates and filters invalid entries

##### 2.1.3 Calculation Flow
```dart
void calculate() async {
  // 1. Validate input
  if (!_formKey.currentState!.validate()) return;
  
  // 2. Parse values
  xValues = parseInput(xController.text);
  yValues = parseInput(yController.text);
  
  // 3. Validate data
  if (xValues.length != yValues.length) {
    _showError("X and Y must have same length");
    return;
  }
  
  // 4. Perform calculation based on curve type
  switch (selectedCurveType) {
    case "1. Fitting straight line":
      calculateStraightLine();
      break;
    case "2. Fitting second degree parabola":
      calculateQuadratic();
      break;
    case "3. Exponential Curves":
      calculateExponential();
      break;
  }
}
```

**Explanation:**
- Validates form input
- Parses X and Y values
- Checks data consistency
- Routes to appropriate calculation method

##### 2.1.4 Straight Line Calculation
```dart
void calculateStraightLine() async {
  int n = xValues.length;
  double sumX = MathUtils.sum(xValues);
  double sumY = MathUtils.sum(yValues);
  double sumX2 = MathUtils.sumSquares(xValues);
  double sumXY = MathUtils.sumProduct(xValues, yValues);
  
  // Form normal equations
  // n·a + sumX·b = sumY
  // sumX·a + sumX2·b = sumXY
  
  // Solve using elimination
  var result = EliminationUtils.solve2x2WithSteps(
    n.toDouble(), sumX, sumY,
    sumX, sumX2, sumXY,
  );
  
  double a = result['a']!;
  double b = result['b']!;
  
  finalEquation = FormatUtils.buildStraightLineEquation(a, b);
}
```

**Mathematical Formula:**
- Normal equations for y = a + bx:
  - Σy = an + bΣx
  - Σxy = aΣx + bΣx²

**Explanation:**
- Calculates all required summations
- Forms system of 2 equations
- Solves using Gaussian elimination
- Formats final equation

##### 2.1.5 Quadratic Calculation
```dart
void calculateQuadratic() async {
  // Calculate all required summations
  double sumX = MathUtils.sum(xValues);
  double sumY = MathUtils.sum(yValues);
  double sumX2 = MathUtils.sumPower(xValues, 2);
  double sumX3 = MathUtils.sumPower(xValues, 3);
  double sumX4 = MathUtils.sumPower(xValues, 4);
  double sumXY = MathUtils.sumProduct(xValues, yValues);
  double sumX2Y = MathUtils.sumPowerTimesY(xValues, yValues, 2);
  
  // Form 3x3 system
  // n·a + sumX·b + sumX2·c = sumY
  // sumX·a + sumX2·b + sumX3·c = sumXY
  // sumX2·a + sumX3·b + sumX4·c = sumX2Y
  
  // Solve using elimination
  var result = EliminationUtils.solve3x3WithSteps(...);
  
  double a = result['a']!;
  double b = result['b']!;
  double c = result['c']!;
  
  finalEquation = FormatUtils.buildQuadraticEquation(a, b, c);
}
```

**Mathematical Formula:**
- Normal equations for y = a + bx + cx²:
  - Σy = an + bΣx + cΣx²
  - Σxy = aΣx + bΣx² + cΣx³
  - Σx²y = aΣx² + bΣx³ + cΣx⁴

##### 2.1.6 Exponential Calculation
```dart
void calculateExponential() async {
  if (selectedExponentialType == "y = aeᵇˣ") {
    // Transform: y = ae^(bx) → log(y) = log(a) + bx·log(e)
    List<double> log10Y = yValues.map((y) => log(y) / ln10).toList();
    
    // Now solve as linear: Y = A + Bx
    // where A = log10(a), B = b·log10(e)
    
    var result = EliminationUtils.solve2x2WithSteps(...);
    double A = result['a']!;
    double B = result['b']!;
    
    // Convert back: a = 10^A, b = B / log10(e)
    double finalA = pow(10, A).toDouble();
    double finalB = B / (log(e) / ln10);
    
    finalEquation = "y = ${finalA} × e^(${finalB}x)";
  }
}
```

**Mathematical Transformation:**
- Exponential: y = ae^(bx)
- Linearize: log₁₀(y) = log₁₀(a) + bx·log₁₀(e)
- Let Y = log₁₀(y), A = log₁₀(a), B = b·log₁₀(e)
- Solve: Y = A + Bx (linear)
- Convert back: a = 10^A, b = B / log₁₀(e)

---

### 2.2 Settings Page (`lib/screens/settings_page.dart`)

#### Purpose
Allows users to customize app appearance (theme, colors).

#### Key Features
- Theme toggle (light/dark)
- Color picker for primary color
- Settings persistence

---

### 2.3 About Page (`lib/screens/about_page.dart`)

#### Purpose
Displays app information, version, credits, and links.

---

## 3. Utility Classes

### 3.1 Math Utils (`lib/utils/math_utils.dart`)

#### Purpose
Provides mathematical calculation functions.

#### Key Functions

##### 3.1.1 Sum Functions
```dart
static double sum(List<double> values) {
  return values.isEmpty ? 0 : values.reduce((a, b) => a + b);
}

static double sumSquares(List<double> values) {
  return values.map((x) => x * x).reduce((a, b) => a + b);
}

static double sumProduct(List<double> x, List<double> y) {
  double result = 0;
  for (int i = 0; i < x.length; i++) {
    result += x[i] * y[i];
  }
  return result;
}
```

**Explanation:**
- `sum()`: Calculates Σx, Σy
- `sumSquares()`: Calculates Σx²
- `sumProduct()`: Calculates Σxy

**Why these functions:**
- Reusable across different curve types
- Clean, readable code
- Efficient calculations

##### 3.1.2 Power Functions
```dart
static double sumPower(List<double> values, int power) {
  return values.map((x) => pow(x, power).toDouble())
    .reduce((a, b) => a + b);
}

static double sumPowerTimesY(List<double> x, List<double> y, int power) {
  double result = 0;
  for (int i = 0; i < x.length; i++) {
    result += pow(x[i], power).toDouble() * y[i];
  }
  return result;
}
```

**Explanation:**
- `sumPower()`: Calculates Σxⁿ (for n=2,3,4 in quadratic)
- `sumPowerTimesY()`: Calculates Σxⁿy (for quadratic)

**Usage:**
- Quadratic fitting requires x², x³, x⁴, x²y
- Exponential may require log transformations

##### 3.1.3 Logarithmic Transform
```dart
static List<double> logTransform(List<double> values) {
  return values.map((x) => log(x)).toList();
}

static bool allPositive(List<double> values) {
  return values.every((x) => x > 0);
}
```

**Explanation:**
- `logTransform()`: Converts values to natural log
- `allPositive()`: Validates data for exponential fitting

**Why needed:**
- Exponential curves require positive values
- Logarithm of negative/zero is undefined

---

### 3.2 Elimination Utils (`lib/utils/elimination_utils.dart`)

#### Purpose
Implements Gaussian elimination with step-by-step tracking.

#### Key Functions

##### 3.2.1 2x2 System Solver
```dart
static Map<String, dynamic> solve2x2WithSteps(
  double a1, double b1, double c1,
  double a2, double b2, double c2,
) {
  // Given: a1·a + b1·b = c1
  //        a2·a + b2·b = c2
  
  // Step 1: Multiply equation 1 by factor
  double factor = a2 / a1;
  // New equation 1: (a1·factor)·a + (b1·factor)·b = c1·factor
  
  // Step 2: Subtract equation 2
  // Eliminate 'a': (b1·factor - b2)·b = c1·factor - c2
  
  // Step 3: Solve for b
  double b = (c1 * factor - c2) / (b1 * factor - b2);
  
  // Step 4: Back-substitute to find a
  double a = (c1 - b1 * b) / a1;
  
  return {'a': a, 'b': b, 'steps': steps};
}
```

**Algorithm:**
1. **Forward Elimination**: Eliminate one variable
2. **Back Substitution**: Solve for remaining variable
3. **Track Steps**: Record each operation for display

**Why step-by-step:**
- Educational purpose
- User can verify calculations
- Debugging tool

##### 3.2.2 3x3 System Solver
```dart
static Map<String, dynamic> solve3x3WithSteps(...) {
  // Step 1: Eliminate 'a' from equations 2 and 3
  // Step 2: Solve resulting 2x2 system for 'b' and 'c'
  // Step 3: Back-substitute to find 'a'
  
  return {'a': a, 'b': b, 'c': c, 'steps': steps};
}
```

**Algorithm:**
1. Eliminate first variable from 2nd and 3rd equations
2. Solve resulting 2x2 system
3. Back-substitute to find all variables

**Numerical Stability:**
- Partial pivoting for accuracy
- Tolerance checks for near-singular matrices
- Error handling for inconsistent systems

---

### 3.3 Format Utils (`lib/utils/format_utils.dart`)

#### Purpose
Formats numbers and equations for display.

#### Key Functions

##### 3.3.1 Number Formatting
```dart
static String formatNumber(double value, {int decimals = 4}) {
  if (value.isNaN) return 'NaN';
  if (value.isInfinite) return value.isNegative ? '-∞' : '∞';
  if (value.abs() < 1e-15) return '0';
  
  String result = value.toStringAsFixed(decimals);
  // Remove trailing zeros
  result = result.replaceAll(RegExp(r'0*$'), '');
  result = result.replaceAll(RegExp(r'\.$'), '');
  return result;
}
```

**Explanation:**
- Handles special cases (NaN, Infinity, zero)
- Formats to specified decimal places
- Removes unnecessary trailing zeros

**Example:**
- `formatNumber(3.14000)` → `"3.14"`
- `formatNumber(5.0)` → `"5"`

##### 3.3.2 Equation Building
```dart
static String buildStraightLineEquation(double a, double b) {
  String aStr = formatNumber(a);
  String bStr = formatNumber(b.abs());
  String sign = b >= 0 ? '+' : '-';
  return 'y = $aStr $sign ${bStr}x';
}

static String buildQuadraticEquation(double a, double b, double c) {
  // Build: y = a + bx + cx²
  // Handle signs properly
  // Simplify if coefficients are zero
}
```

**Explanation:**
- Formats coefficients with proper signs
- Handles positive/negative coefficients
- Simplifies equations when possible

---

### 3.4 Export Utils (`lib/utils/export_utils.dart`)

#### Purpose
Generates PDF documents with calculation results.

#### Key Functions

##### 3.4.1 PDF Generation
```dart
static Future<void> exportAsPDF({
  required String curveType,
  required String finalEquation,
  required List<String> headers,
  required List<List<String>> tableData,
  required List<Map<String, dynamic>> eliminationSteps,
  required BuildContext context,
}) async {
  final pdf = pw.Document();
  
  // Build PDF pages
  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        _buildHeader(),
        _buildInputDataSection(),
        _buildTableSection(),
        _buildEliminationSection(),
      ],
    ),
  );
  
  // Save or share PDF
  if (kIsWeb) {
    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  } else {
    // Save to Downloads folder
    final file = File('${downloadsPath}/$fileName');
    await file.writeAsBytes(await pdf.save());
  }
}
```

**Explanation:**
- Creates multi-page PDF document
- Includes all calculation data
- Platform-specific handling (web vs mobile)

**PDF Structure:**
1. Header with logo and title
2. Input data section
3. Calculation table
4. Step-by-step elimination
5. Final equation

---

### 3.5 Preferences Service (`lib/utils/preferences_service.dart`)

#### Purpose
Manages app settings persistence.

#### Key Functions
```dart
static Future<void> saveThemeMode(ThemeMode mode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('theme_mode', mode.name);
}

static Future<ThemeMode> loadThemeMode() async {
  final prefs = await SharedPreferences.getInstance();
  final modeString = prefs.getString('theme_mode');
  return modeString == 'dark' ? ThemeMode.dark : ThemeMode.light;
}
```

**Explanation:**
- Saves user preferences to device storage
- Loads preferences on app start
- Defaults to light theme if not set

---

## 4. Widgets

### 4.1 Modern Table Widget (`lib/widgets/modern_table_widget.dart`)

#### Purpose
Displays calculation data in a formatted table.

#### Features
- Scrollable for large datasets
- Responsive design
- Theme-aware styling
- Header row highlighting

---

### 4.2 Result Box Widget (`lib/widgets/result_box_widget.dart`)

#### Purpose
Displays final equation and results.

#### Features
- Large, readable equation display
- Copy to clipboard functionality
- Color-coded for visibility

---

### 4.3 Elimination Steps Widget (`lib/widgets/elimination_steps_widget.dart`)

#### Purpose
Shows step-by-step elimination process.

#### Features
- Expandable steps
- Equation formatting
- Visual progression indicators

---

## 5. Mathematical Algorithms

### 5.1 Least Squares Method

#### Theory
Minimizes the sum of squared errors between data points and fitted curve.

#### Implementation
1. Form normal equations from data
2. Solve system using Gaussian elimination
3. Calculate coefficients
4. Build final equation

### 5.2 Gaussian Elimination

#### Algorithm
1. **Forward Elimination**: Eliminate variables from equations
2. **Back Substitution**: Solve for variables from bottom up
3. **Partial Pivoting**: Swap rows for numerical stability

#### Complexity
- Time: O(n³) for n×n system
- Space: O(n²) for matrix storage

---

## 6. Code Flow Diagrams

### 6.1 App Initialization Flow
```
main() 
  → WidgetsFlutterBinding.ensureInitialized()
  → runApp(CurveFittingApp)
  → _CurveFittingAppState.initState()
  → _loadSettings()
  → PreferencesService.loadThemeMode()
  → PreferencesService.loadPrimaryColor()
  → setState() → UI renders
```

### 6.2 Calculation Flow
```
User clicks "Calculate"
  → calculate()
  → validateInput()
  → parseInput()
  → switch (curveType)
    → calculateStraightLine()
    → calculateQuadratic()
    → calculateExponential()
  → MathUtils.sum() / sumSquares() / etc.
  → EliminationUtils.solve2x2WithSteps() / solve3x3WithSteps()
  → FormatUtils.buildEquation()
  → setState() → UI updates
```

### 6.3 PDF Export Flow
```
User clicks "Export PDF"
  → _exportAsPDF()
  → ExportUtils.exportAsPDF()
  → Request permissions (Android)
  → Create PDF document
  → Build sections (header, table, steps)
  → Save to file (mobile) or show preview (web)
  → Share PDF (optional)
```

---

## 7. Key Design Patterns

### 7.1 State Management
- **StatefulWidget**: For widgets that change
- **setState()**: For UI updates
- **SharedPreferences**: For persistence

### 7.2 Separation of Concerns
- **Screens**: UI and user interaction
- **Utils**: Business logic and calculations
- **Widgets**: Reusable UI components

### 7.3 Error Handling
- Try-catch blocks for calculations
- Input validation
- User-friendly error messages

---

## 8. Performance Optimizations

1. **Lazy Loading**: Widgets load only when needed
2. **Caching**: Preferences cached after first load
3. **Efficient Calculations**: Optimized mathematical functions
4. **Minimal Rebuilds**: setState() only when necessary

---

## 9. Testing Considerations

### Unit Tests
- Mathematical functions (MathUtils)
- Formatting functions (FormatUtils)
- Elimination algorithms

### Widget Tests
- UI component rendering
- User interactions
- State changes

### Integration Tests
- Full calculation flow
- PDF export functionality
- Settings persistence

---

## 10. Future Enhancements

1. **Graph Visualization**: Plot data and fitted curve
2. **More Curve Types**: Logarithmic, power curves
3. **Data Import**: CSV/Excel import
4. **Cloud Sync**: Optional cloud backup
5. **Multi-language**: Internationalization

---

## Conclusion

This codebase demonstrates:
- Clean architecture with separation of concerns
- Efficient mathematical algorithms
- User-friendly UI with step-by-step solutions
- Professional PDF export functionality
- Robust error handling and validation

All code is well-documented, maintainable, and follows Flutter best practices.

