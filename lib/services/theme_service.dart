import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal() {
    // Initialize with system theme
    _loadSystemTheme();
  }

  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  void _loadSystemTheme() {
    // Check system brightness
    final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    if (_themeMode == ThemeMode.system) {
      // Will follow system
    }
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setLightMode() {
    setThemeMode(ThemeMode.light);
  }

  void setDarkMode() {
    setThemeMode(ThemeMode.dark);
  }

  void setSystemMode() {
    setThemeMode(ThemeMode.system);
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setDarkMode();
    } else {
      setLightMode();
    }
  }
}
