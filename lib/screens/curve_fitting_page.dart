import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import '../utils/math_utils.dart';
import '../utils/format_utils.dart';
import '../widgets/modern_table_widget.dart';
import '../widgets/result_box_widget.dart';
import '../widgets/elimination_steps_widget.dart';
import '../utils/elimination_utils.dart';
import '../utils/export_utils.dart';

class CurveFittingPage extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onThemeToggle;

  const CurveFittingPage({
    super.key,
    required this.themeMode,
    required this.onThemeToggle,
  });

  @override
  State<CurveFittingPage> createState() => _CurveFittingPageState();
}

class _CurveFittingPageState extends State<CurveFittingPage> {
  final TextEditingController xController = TextEditingController();
  final TextEditingController yController = TextEditingController();
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  String selectedCurveType = "1. Fitting straight line (y = a + bx)";
  String selectedExponentialType = "Fitting exponential equation (y = aeᵇˣ)";

  final List<String> curveTypes = [
    "1. Fitting straight line (y = a + bx)",
    "2. Fitting second degree parabola (y = a + bx + cx²)",
    "3. Exponential Curves",
  ];

  final List<String> exponentialTypes = [
    "Fitting exponential equation (y = aeᵇˣ)",
    "Fitting exponential equation (y = abˣ)",
    "Fitting exponential equation (y = axᵇ)",
  ];

  List<double> xValues = [];
  List<double> yValues = [];
  List<List<String>> tableData = [];
  List<Map<String, dynamic>> eliminationSteps = [];
  String finalEquation = "";
  String bestFit = "";
  List<String> tableHeaders = [];
  String calculationSteps = "";

  @override
  void dispose() {
    xController.dispose();
    yController.dispose();
    super.dispose();
  }

  List<double> parseInput(String input) {
    if (input.trim().isEmpty) return [];

    try {
      return input
          .split(RegExp(r'[,\s]+'))
          .where((e) => e.trim().isNotEmpty)
          .map((e) {
        final parsed = double.tryParse(e.trim());
        if (parsed == null) {
          throw FormatException('Invalid number: $e');
        }
        return parsed;
      })
          .toList();
    } catch (e) {
      return [];
    }
  }

  String? validateInput(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName cannot be empty';
    }

    final values = parseInput(value);
    if (values.isEmpty) {
      return 'Please enter valid numbers separated by spaces or commas';
    }

    return null;
  }

  String _getFormulaText() {
    switch (selectedCurveType) {
      case "1. Fitting straight line (y = a + bx)":
        return """Method: Least Square Method
Equation: y = a + bx
Normal Equations:
  Σy = an + bΣx
  Σxy = aΣx + bΣx²""";
      case "2. Fitting second degree parabola (y = a + bx + cx²)":
        return """Method: Least Square Method
Equation: y = a + bx + cx²
Normal Equations:
  Σy = an + bΣx + cΣx²
  Σxy = aΣx + bΣx² + cΣx³
  Σx²y = aΣx² + bΣx³ + cΣx⁴""";
      case "3. Exponential Curves":
        if (selectedExponentialType == "Fitting exponential equation (y = aeᵇˣ)") {
          return """Method: Least Square Method
Equation: y = aeᵇˣ
Taking log₁₀: log₁₀(y) = log₁₀(a) + bx·log₁₀(e)
Let Y = log₁₀(y), then: Y = A + Bx
Normal Equations:
  ΣY = nA + BΣx
  ΣxY = AΣx + BΣx²""";
        } else if (selectedExponentialType == "Fitting exponential equation (y = abˣ)") {
          return """Method: Least Square Method
Equation: y = abˣ
Taking log₁₀: log₁₀(y) = log₁₀(a) + x·log₁₀(b)
Let Y = log₁₀(y), then: Y = A + Bx
Normal Equations:
  ΣY = nA + BΣx
  ΣxY = AΣx + BΣx²""";
        } else {
          return """Method: Least Square Method
Equation: y = axᵇ
Taking log₁₀: log₁₀(y) = log₁₀(a) + b·log₁₀(x)
Let Y = log₁₀(y), X = log₁₀(x), then: Y = A + bX
Normal Equations:
  ΣY = nA + bΣX
  ΣXY = AΣX + bΣX²""";
        }
      default:
        return "";
    }
  }

  void calculate() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      xValues = parseInput(xController.text);
      yValues = parseInput(yController.text);

      if (xValues.isEmpty || yValues.isEmpty) {
        if (mounted) {
          Navigator.pop(context);
          _showError("Please enter both X and Y values");
        }
        return;
      }

      if (xValues.length != yValues.length) {
        if (mounted) {
          Navigator.pop(context);
          _showError("X and Y must have the same number of values\nX has ${xValues.length} values, Y has ${yValues.length} values");
        }
        return;
      }

      if (xValues.length < 2) {
        if (mounted) {
          Navigator.pop(context);
          _showError("Please enter at least 2 data points");
        }
        return;
      }

      // Clear previous results
      setState(() {
        tableData = [];
        eliminationSteps = [];
        finalEquation = "";
        bestFit = "";
        tableHeaders = [];
        calculationSteps = "";
      });

      // Perform calculation in background
      await Future.delayed(const Duration(milliseconds: 100));

      switch (selectedCurveType) {
        case "1. Fitting straight line (y = a + bx)":
          calculateStraightLine();
          break;
        case "2. Fitting second degree parabola (y = a + bx + cx²)":
          calculateQuadratic();
          break;
        case "3. Exponential Curves":
          calculateExponential();
          break;
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        _showError("Calculation error: ${e.toString()}");
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("⚠️ $message"),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void calculateStraightLine() async {
    try {
      int n = xValues.length;
      double sumX = MathUtils.sum(xValues);
      double sumY = MathUtils.sum(yValues);
      double sumX2 = MathUtils.sumSquares(xValues);
      double sumXY = MathUtils.sumProduct(xValues, yValues);
      
      // Debug log
      print('=== Straight Line Calculation ===');
      print('n=$n, sumX=$sumX, sumY=$sumY, sumX2=$sumX2, sumXY=$sumXY');

      // Build calculation steps text
      calculationSteps = """Given: n = $n data points

Step 1: Calculate summations
Σx = ${xValues.map((x) => FormatUtils.formatNumber(x)).join(' + ')} = ${FormatUtils.formatNumber(sumX)}
Σy = ${yValues.map((y) => FormatUtils.formatNumber(y)).join(' + ')} = ${FormatUtils.formatNumber(sumY)}
Σx² = ${xValues.map((x) => FormatUtils.formatNumber(x * x)).join(' + ')} = ${FormatUtils.formatNumber(sumX2)}
Σxy = ${List.generate(n, (i) => FormatUtils.formatNumber(xValues[i] * yValues[i])).join(' + ')} = ${FormatUtils.formatNumber(sumXY)}

Step 2: Form Normal Equations
Equation 1: Σy = an + bΣx
           ${FormatUtils.formatNumber(sumY)} = a($n) + b(${FormatUtils.formatNumber(sumX)})

Equation 2: Σxy = aΣx + bΣx²
           ${FormatUtils.formatNumber(sumXY)} = a(${FormatUtils.formatNumber(sumX)}) + b(${FormatUtils.formatNumber(sumX2)})""";

      tableHeaders = ['x', 'y', 'x²', 'xy'];
      List<List<String>> rows = [];
      for (int i = 0; i < n; i++) {
        rows.add([
          FormatUtils.formatNumber(xValues[i]),
          FormatUtils.formatNumber(yValues[i]),
          FormatUtils.formatNumber(xValues[i] * xValues[i]),
          FormatUtils.formatNumber(xValues[i] * yValues[i]),
        ]);
      }
      rows.add([
        'Σx = ${FormatUtils.formatNumber(sumX)}',
        'Σy = ${FormatUtils.formatNumber(sumY)}',
        'Σx² = ${FormatUtils.formatNumber(sumX2)}',
        'Σxy = ${FormatUtils.formatNumber(sumXY)}',
      ]);

      try {
        var result = EliminationUtils.solve2x2WithSteps(
          n.toDouble(), sumX, sumY,
          sumX, sumX2, sumXY,
        );

        print('Elimination result: a=${result['a']}, b=${result['b']}, steps count=${result['steps']?.length ?? 0}');

        if (result['a'] != null && result['b'] != null) {
          double a = result['a']!;
          double b = result['b']!;
          
          // Validate the results
          if (a.isNaN || a.isInfinite || b.isNaN || b.isInfinite) {
            throw Exception('Numerical instability detected. Please check your input data.');
          }
          
          eliminationSteps = List<Map<String, dynamic>>.from(result['steps'] as List);
          
          print('Elimination steps assigned: ${eliminationSteps.length} steps');

          calculationSteps += """

Step 3: Solve for a and b (see Elimination Method below)

So, the final equation is: y = ${FormatUtils.formatNumber(a, decimals: 4)} + ${FormatUtils.formatNumber(b, decimals: 4)}x""";

          finalEquation = FormatUtils.buildStraightLineEquation(a, b);
          bestFit = "";
        } else {
          finalEquation = "Error in calculation";
        }
      } on Exception catch (e) {
        String errorMsg = e.toString().replaceAll('Exception: ', '');
        _showError('Calculation error: $errorMsg');
        finalEquation = "Calculation failed - please check your input data";
      }

      setState(() {
        tableData = rows;
      });
      
      print('=== Straight Line Calculation Complete ===');
      print('tableData rows: ${tableData.length}');
      print('eliminationSteps: ${eliminationSteps.length}');
      print('finalEquation: $finalEquation');
    } catch (e, stackTrace) {
      print('=== Error in calculateStraightLine ===');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      finalEquation = "Error: ${e.toString()}";
      setState(() {});
    }
  }

  void calculateQuadratic() async {
    try {
      int n = xValues.length;

      if (n < 3) {
        _showError("Quadratic fitting requires at least 3 data points");
        return;
      }

      double sumX = MathUtils.sum(xValues);
      double sumY = MathUtils.sum(yValues);
      double sumX2 = MathUtils.sumPower(xValues, 2);
      double sumX3 = MathUtils.sumPower(xValues, 3);
      double sumX4 = MathUtils.sumPower(xValues, 4);
      double sumXY = MathUtils.sumProduct(xValues, yValues);
      double sumX2Y = MathUtils.sumPowerTimesY(xValues, yValues, 2);

      // Build calculation steps text
      calculationSteps = """Given: n = $n data points

Step 1: Calculate summations
Σx = ${FormatUtils.formatNumber(sumX)}
Σy = ${FormatUtils.formatNumber(sumY)}
Σx² = ${FormatUtils.formatNumber(sumX2)}
Σx³ = ${FormatUtils.formatNumber(sumX3)}
Σx⁴ = ${FormatUtils.formatNumber(sumX4)}
Σxy = ${FormatUtils.formatNumber(sumXY)}
Σx²y = ${FormatUtils.formatNumber(sumX2Y)}

Step 2: Form Normal Equations
Equation 1: Σy = an + bΣx + cΣx²
           ${FormatUtils.formatNumber(sumY)} = a($n) + b(${FormatUtils.formatNumber(sumX)}) + c(${FormatUtils.formatNumber(sumX2)})

Equation 2: Σxy = aΣx + bΣx² + cΣx³
           ${FormatUtils.formatNumber(sumXY)} = a(${FormatUtils.formatNumber(sumX)}) + b(${FormatUtils.formatNumber(sumX2)}) + c(${FormatUtils.formatNumber(sumX3)})

Equation 3: Σx²y = aΣx² + bΣx³ + cΣx⁴
           ${FormatUtils.formatNumber(sumX2Y)} = a(${FormatUtils.formatNumber(sumX2)}) + b(${FormatUtils.formatNumber(sumX3)}) + c(${FormatUtils.formatNumber(sumX4)})""";

      tableHeaders = ['x', 'y', 'x²', 'x³', 'x⁴', 'xy', 'x²y'];
      List<List<String>> rows = [];
      for (int i = 0; i < n; i++) {
        rows.add([
          FormatUtils.formatNumber(xValues[i]),
          FormatUtils.formatNumber(yValues[i]),
          FormatUtils.formatNumber(pow(xValues[i], 2).toDouble()),
          FormatUtils.formatNumber(pow(xValues[i], 3).toDouble()),
          FormatUtils.formatNumber(pow(xValues[i], 4).toDouble()),
          FormatUtils.formatNumber(xValues[i] * yValues[i]),
          FormatUtils.formatNumber(pow(xValues[i], 2) * yValues[i]),
        ]);
      }
      rows.add([
        'Σx = ${FormatUtils.formatNumber(sumX)}',
        'Σy = ${FormatUtils.formatNumber(sumY)}',
        'Σx² = ${FormatUtils.formatNumber(sumX2)}',
        'Σx³ = ${FormatUtils.formatNumber(sumX3)}',
        'Σx⁴ = ${FormatUtils.formatNumber(sumX4)}',
        'Σxy = ${FormatUtils.formatNumber(sumXY)}',
        'Σx²y = ${FormatUtils.formatNumber(sumX2Y)}',
      ]);

      try {
        var result = EliminationUtils.solve3x3WithSteps(
          n.toDouble(), sumX, sumX2, sumY,
          sumX, sumX2, sumX3, sumXY,
          sumX2, sumX3, sumX4, sumX2Y,
        );

        print('Quadratic elimination result: steps count=${result['steps']?.length ?? 0}');

        if (result['a'] != null && result['b'] != null && result['c'] != null) {
          double a = result['a']!;
          double b = result['b']!;
          double c = result['c']!;
          
          // Validate the results
          if (a.isNaN || a.isInfinite || b.isNaN || b.isInfinite || c.isNaN || c.isInfinite) {
            throw Exception('Numerical instability detected. Please check your input data.');
          }
          
          eliminationSteps = List<Map<String, dynamic>>.from(result['steps'] as List);
          
          print('Quadratic elimination steps assigned: ${eliminationSteps.length} steps');

          calculationSteps += """

Step 3: Solve for a, b, and c (see Elimination Method below)

So, the parabola equation is: y = ${FormatUtils.formatNumber(a, decimals: 4)} + ${FormatUtils.formatNumber(b, decimals: 4)}x + ${FormatUtils.formatNumber(c, decimals: 4)}x²""";

          finalEquation = FormatUtils.buildQuadraticEquation(a, b, c);
          bestFit = "";
        } else {
          finalEquation = "Error in calculation";
        }
      } on Exception catch (e) {
        String errorMsg = e.toString().replaceAll('Exception: ', '');
        if (errorMsg.contains('infinitely many solutions') || errorMsg.contains('no solution')) {
          _showError('Unable to fit parabola: The data points may be collinear or have insufficient variation. Try different data points.');
        } else {
          _showError('Calculation error: $errorMsg');
        }
        finalEquation = "Calculation failed - please check your input data";
      }

      setState(() {
        tableData = rows;
      });
      
      print('=== Quadratic Calculation Complete ===');
      print('eliminationSteps: ${eliminationSteps.length}');
    } catch (e, stackTrace) {
      print('=== Error in calculateQuadratic ===');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      finalEquation = "Error: ${e.toString()}";
      setState(() {});
    }
  }

  void calculateExponential() async {
    try {
      int n = xValues.length;
      String fn(double val, {int decimals = 4}) => FormatUtils.formatNumber(val, decimals: decimals);

      if (selectedExponentialType == "Fitting exponential equation (y = aeᵇˣ)") {
        if (!MathUtils.allPositive(yValues)) {
          _showError("Y values must be positive for exponential type y = aeᵇˣ");
          return;
        }

        List<double> log10Y = yValues.map((y) => log(y) / ln10).toList();
        double sumX = MathUtils.sum(xValues);
        double sumLog10Y = MathUtils.sum(log10Y);
        double sumX2 = MathUtils.sumSquares(xValues);
        double sumXLog10Y = MathUtils.sumProduct(xValues, log10Y);

        calculationSteps = """Given: n = $n data points

Step 1: Transform to linear form
Let Y = log₁₀(y), then equation becomes: Y = A + Bx
where A = log₁₀(a) and B = b·log₁₀(e)

Step 2: Calculate summations
Σx = ${fn(sumX)}
ΣY = ${fn(sumLog10Y)}
Σx² = ${fn(sumX2)}
Σx·Y = ${fn(sumXLog10Y)}

Step 3: Form Normal Equations
Equation 1: ΣY = nA + BΣx
           ${fn(sumLog10Y)} = A($n) + B(${fn(sumX)})

Equation 2: Σx·Y = AΣx + BΣx²
           ${fn(sumXLog10Y)} = A(${fn(sumX)}) + B(${fn(sumX2)})""";

        tableHeaders = ['x', 'y', 'Y = log₁₀(y)', 'x²', 'x·Y'];
        List<List<String>> rows = [];
        for (int i = 0; i < n; i++) {
          rows.add([
            fn(xValues[i]),
            fn(yValues[i]),
            fn(log10Y[i]),
            fn(xValues[i] * xValues[i]),
            fn(xValues[i] * log10Y[i]),
          ]);
        }
        rows.add([
          'Σx = ${fn(sumX)}',
          'Σy = ${fn(MathUtils.sum(yValues))}',
          'ΣY = ${fn(sumLog10Y)}',
          'Σx² = ${fn(sumX2)}',
          'Σx·Y = ${fn(sumXLog10Y)}',
        ]);

        var result = EliminationUtils.solve2x2WithSteps(
          n.toDouble(), sumX, sumLog10Y,
          sumX, sumX2, sumXLog10Y,
        );

        if (result['a'] != null && result['b'] != null) {
          double A = result['a']!;
          double B = result['b']!;
          eliminationSteps = List<Map<String, dynamic>>.from(result['steps'] as List);
          
          print('Exponential (aeᵇˣ) steps assigned: ${eliminationSteps.length} steps');

          double finalA = pow(10, A).toDouble();
          double log10e = log(e) / ln10;
          double finalB = B / log10e;

          calculationSteps += """

Step 4: Solve for A and B (see Elimination Method below)

So, the final equation is: y = ${fn(finalA, decimals: 4)}e^(${fn(finalB, decimals: 4)}x)""";

          // Add conversion step to elimination steps
          eliminationSteps.add({
            'type': 'exponential_conversion',
            'title': 'Step 5: Find a and b',
            'conversions': [
              {
                'variable': 'A',
                'logForm': 'log10(a)',
                'logValue': A,
                'finalVariable': 'a',
                'finalValue': finalA,
                'operation': 'antilog10(${fn(A, decimals: 4)}) = ${fn(finalA, decimals: 4)}'
              },
              {
                'variable': 'B',
                'logForm': 'b·log10(e)',
                'logValue': B,
                'finalVariable': 'b',
                'finalValue': finalB,
                'operation': '${fn(B, decimals: 4)} / ${fn(log10e, decimals: 4)} = ${fn(finalB, decimals: 4)}'
              }
            ]
          });

          finalEquation = "y = ${fn(finalA, decimals: 4)} × e^(${fn(finalB, decimals: 4)}x)";
          bestFit = "";
        } else {
          finalEquation = "Error in calculation";
        }

        setState(() {
          tableData = rows;
        });
      } else if (selectedExponentialType == "Fitting exponential equation (y = abˣ)") {
        if (!MathUtils.allPositive(yValues)) {
          _showError("Y values must be positive for exponential type y = abˣ");
          return;
        }

        List<double> logY = yValues.map((y) => log(y) / ln10).toList();
        double sumX = MathUtils.sum(xValues);
        double sumY = MathUtils.sum(logY);
        double sumX2 = MathUtils.sumSquares(xValues);
        double sumXY = MathUtils.sumProduct(xValues, logY);

        calculationSteps = """Given: n = $n data points

Step 1: Transform to linear form
Let Y = log₁₀(y), then equation becomes: Y = A + Bx
where A = log₁₀(a) and B = log₁₀(b)

Step 2: Calculate summations
Σx = ${fn(sumX)}
ΣY = ${fn(sumY)}
Σx² = ${fn(sumX2)}
Σx·Y = ${fn(sumXY)}

Step 3: Form Normal Equations
Equation 1: ΣY = nA + BΣx
           ${fn(sumY)} = A($n) + B(${fn(sumX)})

Equation 2: Σx·Y = AΣx + BΣx²
           ${fn(sumXY)} = A(${fn(sumX)}) + B(${fn(sumX2)})""";

        tableHeaders = ['x', 'y', 'Y = log₁₀(y)', 'x²', 'x·Y'];
        List<List<String>> rows = [];
        for (int i = 0; i < n; i++) {
          rows.add([
            fn(xValues[i]),
            fn(yValues[i]),
            fn(logY[i]),
            fn(xValues[i] * xValues[i]),
            fn(xValues[i] * logY[i]),
          ]);
        }
        rows.add([
          'Σx = ${fn(sumX)}',
          'Σy = ${fn(MathUtils.sum(yValues))}',
          'ΣY = ${fn(sumY)}',
          'Σx² = ${fn(sumX2)}',
          'Σx·Y = ${fn(sumXY)}',
        ]);

        var result = EliminationUtils.solve2x2WithSteps(
          n.toDouble(), sumX, sumY,
          sumX, sumX2, sumXY,
        );

        if (result['a'] != null && result['b'] != null) {
          double calculatedA = result['a']!;
          double calculatedB = result['b']!;
          eliminationSteps = List<Map<String, dynamic>>.from(result['steps'] as List);
          
          print('Exponential (abˣ) steps assigned: ${eliminationSteps.length} steps');

          double finalA = pow(10, calculatedA).toDouble();
          double finalB = pow(10, calculatedB).toDouble();

          calculationSteps += """

Step 4: Solve for A and B (see Elimination Method below)

So, the final equation is: y = ${fn(finalA, decimals: 4)} * (${fn(finalB, decimals: 4)})^x""";

          // Add conversion step to elimination steps
          eliminationSteps.add({
            'type': 'exponential_conversion',
            'title': 'Step 5: Find a and b',
            'conversions': [
              {
                'variable': 'A',
                'logForm': 'log10(a)',
                'logValue': calculatedA,
                'finalVariable': 'a',
                'finalValue': finalA,
                'operation': 'antilog10(${fn(calculatedA, decimals: 4)}) = ${fn(finalA, decimals: 4)}'
              },
              {
                'variable': 'B',
                'logForm': 'log10(b)',
                'logValue': calculatedB,
                'finalVariable': 'b',
                'finalValue': finalB,
                'operation': 'antilog10(${fn(calculatedB, decimals: 4)}) = ${fn(finalB, decimals: 4)}'
              }
            ]
          });

          finalEquation = "y = ${fn(finalA, decimals: 4)} × (${fn(finalB, decimals: 4)})^x";
          bestFit = "";
        } else {
          finalEquation = "Error in calculation";
        }

        setState(() {
          tableData = rows;
        });
      } else if (selectedExponentialType == "Fitting exponential equation (y = axᵇ)") {
        if (!MathUtils.allPositive(xValues) || !MathUtils.allPositive(yValues)) {
          _showError("Both X and Y values must be positive for exponential type y = axᵇ");
          return;
        }

        List<double> logX = xValues.map((x) => log(x) / ln10).toList();
        List<double> logY = yValues.map((y) => log(y) / ln10).toList();
        double sumLogX = MathUtils.sum(logX);
        double sumLogY = MathUtils.sum(logY);
        double sumLogX2 = logX.map((x) => x * x).reduce((a, b) => a + b);
        double sumLogXY = MathUtils.sumProduct(logX, logY);

        calculationSteps = """Given: n = $n data points

Step 1: Transform to linear form
Let X = log₁₀(x), Y = log₁₀(y), then equation becomes: Y = A + bX
where A = log₁₀(a)

Step 2: Calculate summations
ΣX = ${fn(sumLogX)}
ΣY = ${fn(sumLogY)}
ΣX² = ${fn(sumLogX2)}
ΣX·Y = ${fn(sumLogXY)}

Step 3: Form Normal Equations
Equation 1: ΣY = nA + bΣX
           ${fn(sumLogY)} = A($n) + b(${fn(sumLogX)})

Equation 2: ΣX·Y = AΣX + bΣX²
           ${fn(sumLogXY)} = A(${fn(sumLogX)}) + b(${fn(sumLogX2)})""";

        tableHeaders = ['x', 'y', 'X = log₁₀(x)', 'Y = log₁₀(y)', 'X²', 'X·Y'];
        List<List<String>> rows = [];
        for (int i = 0; i < n; i++) {
          rows.add([
            fn(xValues[i]),
            fn(yValues[i]),
            fn(logX[i]),
            fn(logY[i]),
            fn(logX[i] * logX[i]),
            fn(logX[i] * logY[i]),
          ]);
        }
        rows.add([
          'Σx = ${fn(MathUtils.sum(xValues))}',
          'Σy = ${fn(MathUtils.sum(yValues))}',
          'ΣX = ${fn(sumLogX)}',
          'ΣY = ${fn(sumLogY)}',
          'ΣX² = ${fn(sumLogX2)}',
          'ΣX·Y = ${fn(sumLogXY)}',
        ]);

        var result = EliminationUtils.solve2x2WithSteps(
          n.toDouble(), sumLogX, sumLogY,
          sumLogX, sumLogX2, sumLogXY,
        );

        if (result['a'] != null && result['b'] != null) {
          double calculatedA = result['a']!;
          double calculatedB = result['b']!;
          eliminationSteps = List<Map<String, dynamic>>.from(result['steps'] as List);
          
          print('Exponential (axᵇ) steps assigned: ${eliminationSteps.length} steps');

          double finalA = pow(10, calculatedA).toDouble();
          double finalB = calculatedB;

          calculationSteps += """

Step 4: Solve for A and b (see Elimination Method below)

So, the final equation is: y = ${fn(finalA, decimals: 4)}x^${fn(finalB, decimals: 4)}""";

          // Add conversion step to elimination steps
          eliminationSteps.add({
            'type': 'exponential_conversion',
            'title': 'Step 5: Find a and b',
            'conversions': [
              {
                'variable': 'A',
                'logForm': 'log10(a)',
                'logValue': calculatedA,
                'finalVariable': 'a',
                'finalValue': finalA,
                'operation': 'antilog10(${fn(calculatedA, decimals: 4)}) = ${fn(finalA, decimals: 4)}'
              },
              {
                'variable': 'b',
                'logForm': 'b',
                'logValue': finalB,
                'finalVariable': 'b',
                'finalValue': finalB,
                'operation': 'b = ${fn(finalB, decimals: 4)}'
              }
            ]
          });

          finalEquation = "y = ${fn(finalA, decimals: 4)} × x^${fn(finalB, decimals: 4)}";
          bestFit = "";
        } else {
          finalEquation = "Error in calculation";
        }

        setState(() {
          tableData = rows;
        });
      }
      
      print('=== Exponential Calculation Complete ===');
      print('eliminationSteps: ${eliminationSteps.length}');
    } catch (e, stackTrace) {
      print('=== Error in calculateExponential ===');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      finalEquation = "Error: ${e.toString()}";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Curve Fitting Calculator",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        actions: [
          if (tableData.isNotEmpty)
            IconButton(
              onPressed: _showExportOptions,
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: "Export as PDF",
            ),
          Row(
            children: [
              Icon(
                widget.themeMode == ThemeMode.light ? Icons.light_mode : Icons.dark_mode,
                size: 20,
              ),
              Switch(
                value: widget.themeMode == ThemeMode.dark,
                onChanged: (value) => widget.onThemeToggle(),
                activeThumbColor: colorScheme.onPrimary,
                inactiveThumbColor: colorScheme.onPrimary.withOpacity(0.8),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: RepaintBoundary(
        key: _repaintBoundaryKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 600;
            final isDesktop = constraints.maxWidth > 1200;

            return SingleChildScrollView(
              padding: EdgeInsets.all(isTablet ? 32 : 20),
              child: Form(
                key: _formKey,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isDesktop ? 1200 : double.infinity,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Select Curve Type:",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: colorScheme.primary, width: 2),
                            borderRadius: BorderRadius.circular(10),
                            color: isDark ? (Colors.grey[850]?.withOpacity(0.4) ?? Colors.black26) : colorScheme.primaryContainer.withOpacity(0.2),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedCurveType,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down, color: colorScheme.primary),
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w600
                              ),
                              dropdownColor: isDark ? colorScheme.surface : Colors.white,
                              items: curveTypes.map((String type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Row(
                                    children: [
                                      Icon(Icons.functions, size: 20, color: colorScheme.primary),
                                      const SizedBox(width: 10),
                                      Flexible(child: Text(type, overflow: TextOverflow.ellipsis)),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCurveType = newValue!;
                                  tableData = [];
                                  eliminationSteps = [];
                                  finalEquation = "";
                                  calculationSteps = "";
                                });
                              },
                            ),
                          ),
                        ),
                        if (selectedCurveType == "3. Exponential Curves") ...[
                          const SizedBox(height: 16),
                          Text(
                              "Select Exponential Type:",
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface
                              )
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: exponentialTypes.map((type) {
                              return ChoiceChip(
                                label: Text(type, style: const TextStyle(fontSize: 13)),
                                selected: selectedExponentialType == type,
                                selectedColor: colorScheme.primaryContainer,
                                onSelected: (selected) {
                                  setState(() {
                                    selectedExponentialType = type;
                                    tableData = [];
                                    eliminationSteps = [];
                                    finalEquation = "";
                                    calculationSteps = "";
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                        const SizedBox(height: 20),

                        // Formula Display
                        InfoBoxWidget(
                          title: "Formula & Normal Equations",
                          content: _getFormulaText(),
                          icon: Icons.info_outline,
                          color: colorScheme.secondary,
                        ),
                        const SizedBox(height: 20),

                        Text(
                            "Enter x values (comma or space separated):",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface
                            )
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: xController,
                          style: TextStyle(color: colorScheme.onSurface),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                          validator: (value) => validateInput(value, "X values"),
                          decoration: InputDecoration(
                            hintText: "Example: 1 2 3 4 5",
                            hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
                            filled: true,
                            fillColor: isDark ? (Colors.grey[850]?.withOpacity(0.4) ?? Colors.black26) : colorScheme.primaryContainer.withOpacity(0.1),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: colorScheme.primary, width: 2)
                            ),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: colorScheme.error, width: 2)
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                            "Enter y values (comma or space separated):",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface
                            )
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: yController,
                          style: TextStyle(color: colorScheme.onSurface),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                          validator: (value) => validateInput(value, "Y values"),
                          decoration: InputDecoration(
                            hintText: "Example: 2.4 3 3.6 4 5",
                            hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
                            filled: true,
                            fillColor: isDark ? (Colors.grey[850]?.withOpacity(0.4) ?? Colors.black26) : colorScheme.primaryContainer.withOpacity(0.1),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: colorScheme.primary, width: 2)
                            ),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: colorScheme.error, width: 2)
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: calculate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 4,
                            ),
                            icon: const Icon(Icons.calculate, size: 24),
                            label: Text(
                                "Calculate Curve Fitting",
                                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Results Section
                        if (tableData.isNotEmpty) ...[
                          ModernTableWidget(
                            title: "📊 Computed Values Table",
                            titleIcon: Icons.table_chart,
                            headers: tableHeaders,
                            rows: tableData,
                          ),
                          const SizedBox(height: 32),
                        ],

                        if (calculationSteps.isNotEmpty) ...[
                          InfoBoxWidget(
                            title: "📝 Calculation Steps",
                            content: calculationSteps,
                            icon: Icons.calculate_outlined,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 32),
                        ],

                        if (eliminationSteps.isNotEmpty) ...[
                          EliminationStepsWidget(steps: eliminationSteps),
                          const SizedBox(height: 32),
                        ],

                        if (finalEquation.isNotEmpty) ...[
                          EquationBoxWidget(
                            title: "✅ Final Result",
                            icon: Icons.functions,
                            equation: finalEquation,
                            subtitle: bestFit,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showExportOptions() {
    if (tableData.isEmpty && eliminationSteps.isEmpty) {
      _showError("No data to export. Please calculate first.");
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              "Export Options",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
              title: const Text("Export as PDF"),
              subtitle: const Text("Complete report with all calculations"),
              onTap: () {
                Navigator.pop(context);
                _exportAsPDF();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _exportAsPDF() {
    if (tableData.isEmpty) {
        _showError("Cannot export an empty table.");
        return;
    }
    try {
      final sumRow = tableData.last;
      final dataRows = tableData.sublist(0, tableData.length - 1);

      ExportUtils.exportAsPDF(
        curveType: selectedCurveType,
        finalEquation: finalEquation,
        headers: tableHeaders,
        tableData: dataRows,
        sumRow: sumRow,
        eliminationSteps: eliminationSteps,
        context: context,
        calculationSteps: calculationSteps,
        xValues: xValues,
        yValues: yValues,
      );
    } catch (e) {
      _showError("Export failed: ${e.toString()}");
    }
  }
}

// InfoBoxWidget class
class InfoBoxWidget extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color color;

  const InfoBoxWidget({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? color.withOpacity(0.15)
            : color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.2)
                  : Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              content,
              style: GoogleFonts.robotoMono(
                fontSize: 14,
                color: colorScheme.onSurface,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
