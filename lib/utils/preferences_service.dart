import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _themeModeKey = 'theme_mode';
  static const String _primaryColorKey = 'primary_color';

  // Save theme mode
  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
  }

  // Load theme mode (defaults to light)
  static Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themeModeKey);
    
    if (themeModeString == null) {
      // Default to light mode for first-time users
      return ThemeMode.light;
    }
    
    switch (themeModeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  // Save primary color
  static Future<void> savePrimaryColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_primaryColorKey, color.value);
  }

  // Load primary color (defaults to deepPurple)
  static Future<Color> loadPrimaryColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt(_primaryColorKey);
    
    if (colorValue == null) {
      // Default to deepPurple
      return Colors.deepPurple;
    }
    
    return Color(colorValue);
  }

  // Clear all preferences
  static Future<void> clearAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Reset to defaults
  static Future<void> resetToDefaults() async {
    await saveThemeMode(ThemeMode.light);
    await savePrimaryColor(Colors.deepPurple);
  }
}

