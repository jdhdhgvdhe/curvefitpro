import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/curve_fitting_page.dart';

void main() {
  runApp(const CurveFittingApp());
}

class CurveFittingApp extends StatefulWidget {
  const CurveFittingApp({super.key});

  @override
  State<CurveFittingApp> createState() => _CurveFittingAppState();
}

class _CurveFittingAppState extends State<CurveFittingApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Curve Fitting Calculator",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      themeMode: _themeMode,
      home: CurveFittingPage(
        themeMode: _themeMode,
        onThemeToggle: toggleTheme,
      ),
    );
  }
}