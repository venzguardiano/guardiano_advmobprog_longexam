import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Manages theme state (Light by default) and saves choice to SharedPreferences
class ThemeProvider extends ChangeNotifier {
  bool _isDark = false; // Default is now Light mode

  bool get isDark => _isDark;

  // Loads saved theme preference from storage (defaults to false / Light mode)
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('darkModeEnabled') ?? false;
    notifyListeners();
  }

  // Toggles between light and dark mode and saves choice
  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkModeEnabled', _isDark);
  }
}
