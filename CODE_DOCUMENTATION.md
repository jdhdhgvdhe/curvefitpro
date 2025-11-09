# 📚 Code Documentation

This document provides detailed explanations of the codebase structure, key components, and implementation details.

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point and theme management
├── screens/                     # UI screens
│   ├── curve_fitting_page.dart # Main calculation interface
│   ├── settings_page.dart       # Theme and preferences
│   ├── about_page.dart         # App information
│   └── history_page.dart       # Calculation history
├── utils/                       # Business logic
│   ├── math_utils.dart         # Mathematical calculations
│   ├── elimination_utils.dart  # Step-by-step elimination
│   ├── export_utils.dart       # PDF generation
│   ├── format_utils.dart       # Data formatting
│   └── preferences_service.dart # Settings persistence
└── widgets/                     # Reusable UI components
    ├── modern_table_widget.dart
    ├── result_box_widget.dart
    ├── elimination_steps_widget.dart
    ├── equation_box.dart
    └── color_picker_widget.dart
```

---

## 🎯 Main Application (`main.dart`)

### Purpose
Entry point of the application. Manages app-wide state, theme, and navigation.

### Key Components

#### 1. `CurveFittingApp` (StatefulWidget
- Root widget of the application
- Manages theme mode (light/dark)
- Handles primary color customization
- Loads saved preferences on startup

#### 2. Theme Management
```dart
ThemeMode _themeMode = ThemeMode.light;
Color _primaryColor = Colors.deepPurple;
```
- Stores current theme state
- Persists to SharedPreferences
- Updates UI reactively

#### 3. Navigation
- Bottom navigation bar
- Tab-based navigation between screens
- Maintains state across tab switches

### Code Flow
1. App starts → `main()` called
2. `WidgetsFlutterBinding.ensureInitialized()` → Prepares Flutter
3. `CurveFittingApp()` → Creates app widget
4. `_loadSettings()` → Loads saved preferences
5. UI renders with saved theme/color

---

## 🧮 Mathematical Calculations (`math_utils.dart`)

### Purpose
Core mathematical functions for curve fitting calculations.

### Key Functions

#### 1. `sum(List<double> values)`
- **Purpose**: Calculate sum of a list
- **Usage**: `Σx`, `Σy` calculations
- **Example**: `sum([1, 2, 3])` → `6.0`

#### 2. `sumSquares(List<double> values)`
- **Purpose**: Sum of squares
- **Usage**: `Σx²` calculations
- **Example**: `sumSquares([1, 2, 3])` → `14.0` (1² + 2² + 3²)

#### 3. `sumProduct(List<double> x, List<double> y)`
- **Purpose**: Sum of products
- **Usage**: `Σxy` calculations
- **Example**: `sumProduct([1, 2], [3, 4])` → `11.0` (1×3 + 2×4)

#### 4. `sumPower(List<double> values, int power)`
- **Purpose**: Sum of values raised to a power
- **Usage**: `Σx³`, `Σx⁴` for quadratic fitting
- **Example**: `sumPower([1, 2], 3)` → `9.0` (1³ + 2³)

### Mathematical Formulas

#### Linear Fitting: `y = ax + b`
```
a = (nΣxy - ΣxΣy) / (nΣx² - (Σx)²)
b = (Σy - aΣx) / n
```

#### Quadratic Fitting: `y = ax² + bx + c`
Uses system of equations:
```
n·c + Σx·b + Σx²·a = Σy
Σx·c + Σx²·b + Σx³·a = Σxy
Σx²·c + Σx³·b + Σx⁴·a = Σx²y
```

#### Exponential Fitting: `y = ae^(bx)`
Linearized to: `ln(y) = ln(a) + bx`
Then solved as linear equation.

---

## 🔢 Elimination Method (`elimination_utils.dart`)

### Purpose
Implements Gaussian elimination for solving systems of equations.

### Key Functions

#### 1. `solveLinearSystem(List<List<double>> matrix)`
- **Purpose**: Solves 2×2 system for linear fitting
- **Method**: Gaussian elimination
- **Returns**: Solution vector [a, b]

#### 2. `solveQuadraticSystem(List<List<double>> matrix)`
- **Purpose**: Solves 3×3 system for quadratic fitting
- **Method**: Gaussian elimination with partial pivoting
- **Returns**: Solution vector [a, b, c]

#### 3. `eliminateStep(List<List<double>> matrix, int step)`
- **Purpose**: Performs one elimination step
- **Returns**: Step-by-step details for display
- **Usage**: Shows user how elimination works

### Algorithm Flow

1. **Forward Elimination**:
   - Make diagonal elements 1
   - Eliminate elements below diagonal
   - Show each step

2. **Back Substitution**:
   - Solve from bottom to top
   - Calculate each variable
   - Display final solution

### Example
```
Original System:
[2, 1, 5]
[1, 3, 7]

Step 1: Divide row 1 by 2
[1, 0.5, 2.5]
[1, 3, 7]

Step 2: Subtract row 1 from row 2
[1, 0.5, 2.5]
[0, 2.5, 4.5]

Step 3: Solve for b
b = 4.5 / 2.5 = 1.8

Step 4: Solve for a
a = 2.5 - 0.5(1.8) = 1.6
```

---

## 📄 PDF Export (`export_utils.dart`)

### Purpose
Generates professional PDF documents with calculation results.

### Key Functions

#### 1. `generatePDF(...)`
- **Purpose**: Main PDF generation function
- **Input**: Calculation data, results, steps
- **Output**: PDF document bytes
- **Features**:
  - Multi-page support
  - Custom styling
  - Tables and equations
  - Step-by-step solutions

#### 2. PDF Structure
```dart
// Page 1: Header and Summary
- App name and logo
- Calculation date
- Curve type
- Final equation

// Page 2: Data Table
- Input data (X, Y values)
- Calculated sums (Σx, Σy, Σxy, etc.)

// Page 3+: Step-by-Step Solutions
- Each elimination step
- Equations and transformations
- Final coefficients
```

#### 3. Styling
- Custom fonts (Poppins)
- Color-coded sections
- Professional layout
- Print-friendly design

---

## 🎨 UI Components

### 1. `ModernTableWidget`
- **Purpose**: Displays data input table
- **Features**:
  - Add/remove rows
  - Input validation
  - Real-time updates
  - Scrollable for many rows

### 2. `ResultBoxWidget`
- **Purpose**: Displays calculation results
- **Features**:
  - Equation display
  - Coefficient values
  - Formatted output
  - Copy functionality

### 3. `EliminationStepsWidget`
- **Purpose**: Shows step-by-step elimination
- **Features**:
  - Expandable steps
  - Equation formatting
  - Visual progression
  - Scrollable list

### 4. `ColorPickerWidget`
- **Purpose**: Theme color selection
- **Features**:
  - Color palette
  - Preview
  - Save preference
  - Smooth transitions

---

## 🔧 Utility Functions

### `format_utils.dart`
- **Purpose**: Data formatting and display
- **Functions**:
  - `formatNumber()`: Formats decimals
  - `formatEquation()`: Formats equations
  - `formatStep()`: Formats elimination steps

### `preferences_service.dart`
- **Purpose**: Settings persistence
- **Functions**:
  - `saveThemeMode()`: Save theme preference
  - `loadThemeMode()`: Load theme preference
  - `savePrimaryColor()`: Save color preference
  - `loadPrimaryColor()`: Load color preference

---

## 📱 Screen Implementations

### `curve_fitting_page.dart`
Main calculation interface:
- Data input table
- Curve type selection
- Calculate button
- Results display
- Step-by-step solutions
- Export options

### `settings_page.dart`
App settings:
- Theme toggle (light/dark)
- Color picker
- About information
- Reset options

### `history_page.dart`
Calculation history:
- List of past calculations
- Quick access to results
- Delete functionality
- Clear all option

### `about_page.dart`
App information:
- Version number
- Developer credits
- Links to resources
- License information

---

## 🎯 Design Patterns Used

### 1. **State Management**
- StatefulWidget for local state
- setState() for UI updates
- SharedPreferences for persistence

### 2. **Separation of Concerns**
- UI in screens/
- Logic in utils/
- Reusable components in widgets/

### 3. **Single Responsibility**
- Each file has one clear purpose
- Functions are focused and small
- Easy to test and maintain

### 4. **DRY Principle**
- Reusable utility functions
- Shared widgets
- Common formatting functions

---

## 🔍 Key Algorithms

### 1. Least Squares Method
- Minimizes sum of squared errors
- Provides best-fit curve
- Standard in regression analysis

### 2. Gaussian Elimination
- Solves system of linear equations
- O(n³) complexity for n×n system
- Numerically stable with pivoting

### 3. Exponential Linearization
- Transforms y = ae^(bx) to linear form
- Uses natural logarithm
- Solves as linear equation

---

## 🧪 Testing

### Test Files
- `elimination_test.dart`: Tests mathematical functions
- `widget_test.dart`: Tests UI components

### Test Coverage
- Mathematical calculations
- Edge cases (empty data, single point)
- UI interactions
- Theme switching

---

## 🚀 Performance Optimizations

1. **Lazy Loading**: Widgets load only when needed
2. **Caching**: Preferences cached after first load
3. **Efficient Calculations**: Optimized mathematical functions
4. **Minimal Rebuilds**: setState() only when necessary
5. **Asset Optimization**: Compressed images and fonts

---

## 🔒 Security & Privacy

1. **No Data Collection**: All calculations local
2. **No Network Calls**: Works completely offline
3. **No Analytics**: No tracking or telemetry
4. **Local Storage Only**: Preferences stored locally
5. **No Third-Party Services**: Except Google Fonts (optional)

---

## 📝 Code Style

- Follows Flutter/Dart style guide
- Uses meaningful variable names
- Comments for complex logic
- Consistent formatting
- Proper error handling

---

## 🐛 Error Handling

- Input validation
- Try-catch blocks
- User-friendly error messages
- Graceful degradation
- Logging for debugging

---

## 🔄 Future Improvements

1. **Graph Visualization**: Plot data and fitted curve
2. **More Curve Types**: Logarithmic, power curves
3. **Data Import**: CSV/Excel import
4. **Cloud Sync**: Optional cloud backup
5. **Multi-language**: Internationalization

