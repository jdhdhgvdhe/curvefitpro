import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/curve_fitting_page.dart';
import 'screens/settings_page.dart';
import 'screens/about_page.dart';
import 'utils/preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CurveFittingApp());
}

class CurveFittingApp extends StatefulWidget {
  const CurveFittingApp({super.key});

  @override
  State<CurveFittingApp> createState() => _CurveFittingAppState();
}

class _CurveFittingAppState extends State<CurveFittingApp> {
  ThemeMode _themeMode = ThemeMode.light; // Default to light mode
  Color _primaryColor = Colors.deepPurple;
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load saved settings from SharedPreferences
  Future<void> _loadSettings() async {
    final themeMode = await PreferencesService.loadThemeMode();
    final primaryColor = await PreferencesService.loadPrimaryColor();
    
    setState(() {
      _themeMode = themeMode;
      _primaryColor = primaryColor;
      _isLoading = false;
    });
  }

  void _toggleTheme(ThemeMode mode) async {
    setState(() {
      _themeMode = mode;
    });
    // Save the theme mode preference
    await PreferencesService.saveThemeMode(mode);
  }

  void _changePrimaryColor(Color color) async {
    setState(() {
      _primaryColor = color;
    });
    // Save the color preference
    await PreferencesService.savePrimaryColor(color);
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while settings are being loaded
    if (_isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: _primaryColor,
            ),
          ),
        ),
      );
    }

    final List<Widget> pages = [
      CurveFittingPage(
        themeMode: _themeMode,
        onThemeToggle: () => _toggleTheme(
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
        ),
      ),
      SettingsPage(
        currentThemeMode: _themeMode,
        currentPrimaryColor: _primaryColor,
        onThemeModeChanged: _toggleTheme,
        onPrimaryColorChanged: _changePrimaryColor,
      ),
      const AboutPage(),
    ];

    return MaterialApp(
      title: "CurveFitPro",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).primaryTextTheme,
        ),
      ),
      themeMode: _themeMode,
      home: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.calculate_outlined),
              selectedIcon: Icon(Icons.calculate),
              label: 'Calculator',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
            NavigationDestination(
              icon: Icon(Icons.info_outline),
              selectedIcon: Icon(Icons.info),
              label: 'About',
            ),
          ],
        ),
      ),
    );
  }
}
