import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isCelsius = true;

  bool get isDarkMode => _isDarkMode;
  bool get isCelsius => _isCelsius;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _isCelsius = prefs.getBool('isCelsius') ?? true;
    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    notifyListeners();
  }

  Future<void> toggleUnit(bool value) async {
    _isCelsius = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCelsius', value);
    notifyListeners();
  }
}