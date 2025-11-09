import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/color_picker_widget.dart';
import '../utils/preferences_service.dart';
import 'about_page.dart';

class SettingsPage extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final Color currentPrimaryColor;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final ValueChanged<Color> onPrimaryColorChanged;

  const SettingsPage({
    super.key,
    required this.currentThemeMode,
    required this.currentPrimaryColor,
    required this.onThemeModeChanged,
    required this.onPrimaryColorChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ThemeMode _currentThemeMode;
  late Color _currentPrimaryColor;

  @override
  void initState() {
    super.initState();
    _currentThemeMode = widget.currentThemeMode;
    _currentPrimaryColor = widget.currentPrimaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        actions: [
          IconButton(
            onPressed: _resetToDefaults,
            icon: const Icon(Icons.restore),
            tooltip: "Reset to Defaults",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Settings Section
            _buildSectionHeader(
              context,
              "Appearance",
              Icons.palette,
              colorScheme,
            ),
            const SizedBox(height: 16),

            // Dark/Light Mode Toggle
            _buildSettingCard(
              context,
              "Theme Mode",
              "Choose between light and dark theme",
              Icons.brightness_6,
              colorScheme,
              isDark,
              child: Row(
                children: [
                  Icon(
                    _currentThemeMode == ThemeMode.light ? Icons.light_mode : Icons.dark_mode,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _currentThemeMode == ThemeMode.light ? "Light Mode" : "Dark Mode",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: _currentThemeMode == ThemeMode.dark,
                    onChanged: (value) {
                      setState(() {
                        _currentThemeMode = value ? ThemeMode.dark : ThemeMode.light;
                      });
                      widget.onThemeModeChanged(_currentThemeMode);
                    },
                    activeThumbColor: colorScheme.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Primary Color Picker
            ColorPickerWidget(
              selectedColor: _currentPrimaryColor,
              onColorChanged: (color) {
                setState(() {
                  _currentPrimaryColor = color;
                });
                widget.onPrimaryColorChanged(color);
              },
              title: "Primary Color",
            ),
            const SizedBox(height: 32),

            // Information Section
            _buildSectionHeader(
              context,
              "Information",
              Icons.info,
              colorScheme,
            ),
            const SizedBox(height: 16),

            // About App
            _buildSettingCard(
              context,
              "About App",
              "Learn more about the app and development team",
              Icons.info_outline,
              colorScheme,
              isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
            const SizedBox(height: 12),

            // Version Info
            _buildSettingCard(
              context,
              "Version Information",
              "App version and build details",
              Icons.info,
              colorScheme,
              isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow("Version", "1.0.0", colorScheme),
                  _buildInfoRow("Build", "1", colorScheme),
                  _buildInfoRow("Flutter", "3.9.2+", colorScheme),
                  _buildInfoRow("Dart", "3.0.0+", colorScheme),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Privacy Policy
            _buildSettingCard(
              context,
              "Privacy Policy",
              "How we handle your data and privacy",
              Icons.privacy_tip,
              colorScheme,
              isDark,
              onTap: _showPrivacyPolicy,
            ),
            const SizedBox(height: 12),

            // Terms of Service
            _buildSettingCard(
              context,
              "Terms of Service",
              "Terms and conditions for using the app",
              Icons.description,
              colorScheme,
              isDark,
              onTap: _showTermsOfService,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: colorScheme.primary,
          size: 24,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    ColorScheme colorScheme,
    bool isDark, {
    Widget? child,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? (Colors.grey[850]?.withOpacity(0.4) ?? Colors.black26) : colorScheme.primaryContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child ??
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (onTap != null)
                      Icon(
                        Icons.arrow_forward_ios,
                        color: colorScheme.onSurface.withOpacity(0.5),
                        size: 16,
                      ),
                  ],
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Reset to Defaults",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "This will reset all settings to their default values. Are you sure?",
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              // Reset to defaults and save
              await PreferencesService.resetToDefaults();
              
              setState(() {
                _currentThemeMode = ThemeMode.light;
                _currentPrimaryColor = Colors.deepPurple;
              });
              widget.onThemeModeChanged(_currentThemeMode);
              widget.onPrimaryColorChanged(_currentPrimaryColor);
              Navigator.of(context).pop();
              
              // Show confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '✅ Settings reset to defaults',
                    style: GoogleFonts.poppins(),
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Privacy Policy",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Text(
            "This app does not collect, store, or transmit any personal data. All calculations are performed locally on your device. We respect your privacy and do not track your usage.",
            style: GoogleFonts.poppins(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Terms of Service",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Text(
            "By using this app, you agree to use it responsibly for educational and professional purposes. The app is provided as-is without warranty.",
            style: GoogleFonts.poppins(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }
}
