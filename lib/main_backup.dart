import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

void main() {
  runApp(const CurveFittingApp());
}

class CurveFittingApp extends StatelessWidget {
  const CurveFittingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Curve Fitting using Linear Regression (Least Squares Method)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A90E2),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const CurveFittingHome(),
    );
  }
}

class CurveFittingHome extends StatefulWidget {
  const CurveFittingHome({super.key});

  @override
  State<CurveFittingHome> createState() => _CurveFittingHomeState();
}

class _CurveFittingHomeState extends State<CurveFittingHome> with SingleTickerProviderStateMixin {
  final TextEditingController xController = TextEditingController();
  final TextEditingController yController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  double? a, b, sumX, sumY, sumX2, sumXY;
  List<double> x = [];
  List<double> y = [];
  String steps = "";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    xController.dispose();
    yController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  List<double> parseInput(String input) {
    return input
        .split(RegExp(r'[ ,]+'))
        .where((e) => e.isNotEmpty)
        .map((e) => double.tryParse(e) ?? 0)
        .toList();
  }

  void computeRegression() {
    setState(() {
      x = parseInput(xController.text);
      y = parseInput(yController.text);
    });

    if (x.length != y.length || x.isEmpty) {
      setState(() {
        steps = "⚠️ Please enter equal numbers of x and y values.";
      });
      return;
    }

    int n = x.length;
    sumX = x.reduce((a, b) => a + b);
    sumY = y.reduce((a, b) => a + b);
    sumXY = 0;
    sumX2 = 0;

    for (int i = 0; i < n; i++) {
      sumXY = sumXY! + x[i] * y[i];
      sumX2 = sumX2! + pow(x[i], 2);
    }

    // Normal equations
    // Σy = n*a + b*Σx
    // Σxy = a*Σx + b*Σx²
    double eq1_a = n.toDouble();
    double eq1_b = sumX!;
    double eq1_c = sumY!;
    double eq2_a = sumX!;
    double eq2_b = sumX2!;
    double eq2_c = sumXY!;

    // Elimination (multiply eq1 by factor to eliminate a)
    double m = eq2_a / eq1_a;
    double newEq1_a = eq1_a * m;
    double newEq1_b = eq1_b * m;
    double newEq1_c = eq1_c * m;

    double elimB = eq2_b - newEq1_b;
    double elimC = eq2_c - newEq1_c;

    b = elimC / elimB;
    a = (eq1_c - eq1_b * b!) / eq1_a;

    // Generate detailed steps
    steps = """
📘 Given Data:
x = ${x.join(", ")}
y = ${y.join(", ")}

🧮 Step 1: Calculate Summations
n = $n
Σx = ${sumX!.toStringAsFixed(4)}
Σy = ${sumY!.toStringAsFixed(4)}
Σxy = ${sumXY!.toStringAsFixed(4)}
Σx² = ${sumX2!.toStringAsFixed(4)}

📐 Step 2: Form Normal Equations
Equation 1: Σy = n·a + b·Σx
Equation 2: Σxy = a·Σx + b·Σx²

Substituting values:
Eq1: ${sumY!.toStringAsFixed(4)} = ${n}a + ${sumX!.toStringAsFixed(4)}b
Eq2: ${sumXY!.toStringAsFixed(4)} = ${sumX!.toStringAsFixed(4)}a + ${sumX2!.toStringAsFixed(4)}b

🔧 Step 3: Elimination Method
Multiply Equation 1 by ${m.toStringAsFixed(4)} (to eliminate 'a'):
${(eq1_c * m).toStringAsFixed(4)} = ${(eq1_a * m).toStringAsFixed(4)}a + ${(eq1_b * m).toStringAsFixed(4)}b

Subtract this from Equation 2:
${eq2_c.toStringAsFixed(4)} - ${(eq1_c * m).toStringAsFixed(4)} = (${eq2_b.toStringAsFixed(4)} - ${(eq1_b * m).toStringAsFixed(4)})b
${elimC.toStringAsFixed(4)} = ${elimB.toStringAsFixed(4)}b

Solve for b:
b = ${elimC.toStringAsFixed(4)} ÷ ${elimB.toStringAsFixed(4)}
b = ${b!.toStringAsFixed(6)}

🔙 Step 4: Back Substitution
Substitute b = ${b!.toStringAsFixed(6)} into Equation 1:
${sumY!.toStringAsFixed(4)} = ${n}a + ${sumX!.toStringAsFixed(4)} × ${b!.toStringAsFixed(6)}
${sumY!.toStringAsFixed(4)} = ${n}a + ${(sumX! * b!).toStringAsFixed(4)}
${n}a = ${sumY!.toStringAsFixed(4)} - ${(sumX! * b!).toStringAsFixed(4)}
${n}a = ${(sumY! - sumX! * b!).toStringAsFixed(4)}
a = ${a!.toStringAsFixed(6)}

✅ Final Regression Equation:
y = ${a!.toStringAsFixed(6)} + ${b!.toStringAsFixed(6)}x

Or simplified:
y = ${a!.toStringAsFixed(4)} + ${b!.toStringAsFixed(4)}x
""";
    setState(() {
      _animationController.forward(from: 0);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Curve Fitting (Elimination Method)',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F4F8), Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input Card
              Card(
                elevation: 6,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.input_rounded, color: Color(0xFF4A90E2), size: 28),
                          const SizedBox(width: 12),
                          Text(
                            'Enter Data Points',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF4A90E2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Enter X values (comma or space separated):',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: xController,
                        decoration: InputDecoration(
                          hintText: 'Example: 1 2 3 4 6 8',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.functions),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Enter Y values (comma or space separated):',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: yController,
                        decoration: InputDecoration(
                          hintText: 'Example: 2.4 3 3.6 4 5 6',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.functions),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: computeRegression,
                          icon: const Icon(Icons.calculate_rounded, size: 24),
                          label: Text(
                            'Compute Curve Fitting',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A90E2),
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: const Color(0xFF4A90E2).withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              // Detailed Steps Section
              if (steps.isNotEmpty)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      // Step-by-Step Solution Card
                      Card(
                        elevation: 6,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.auto_stories, color: Color(0xFF4A90E2), size: 28),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Step-by-Step Solution',
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4A90E2),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFF4A90E2).withValues(alpha: 0.3)),
                                ),
                                child: SelectableText(
                                  steps,
                                  style: GoogleFonts.robotoMono(
                                    fontSize: 14,
                                    height: 1.6,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),

                      // Data Table Card
                      if (x.isNotEmpty && a != null && b != null)
                        Card(
                          elevation: 6,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.table_chart_rounded, color: Color(0xFF4A90E2), size: 28),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Computed Table:',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF4A90E2),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(
                                      const Color(0xFF4A90E2).withValues(alpha: 0.15),
                                    ),
                                    border: TableBorder.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    columns: [
                                      DataColumn(
                                        label: Text(
                                          'x',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'y (actual)',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'y (calculated)',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: List.generate(x.length, (i) {
                                      final isEven = i % 2 == 0;
                                      final yCalc = a! + b! * x[i];
                                      return DataRow(
                                        color: WidgetStateProperty.all(
                                          isEven ? Colors.white : Colors.grey.shade50,
                                        ),
                                        cells: [
                                          DataCell(Text(
                                            x[i].toStringAsFixed(2),
                                            style: GoogleFonts.robotoMono(),
                                          )),
                                          DataCell(Text(
                                            y[i].toStringAsFixed(2),
                                            style: GoogleFonts.robotoMono(),
                                          )),
                                          DataCell(Text(
                                            yCalc.toStringAsFixed(4),
                                            style: GoogleFonts.robotoMono(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue.shade700,
                                            ),
                                          )),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
