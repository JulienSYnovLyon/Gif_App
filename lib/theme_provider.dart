// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  // Variables pour le thème clair
  ThemeData _lightTheme = ThemeData(
    primarySwatch: Colors.indigo,
  );

  // Variables pour le thème sombre
  ThemeData _darkTheme = ThemeData(
    primarySwatch: Colors.indigo,
    brightness: Brightness.dark,
  );

  // Initialiser les préférences utilisateur
  late SharedPreferences _prefs;
  late bool _isDarkMode;

  ThemeProvider() {
    _loadPrefs();
  }

  // Charger les préférences utilisateur
  Future<void> _loadPrefs() async {
    // Marquer la méthode comme async
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  // Basculez le mode sombre / clair
  void toggleTheme(bool value) {
    _isDarkMode = value;
    _prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  // Récupérer le thème actuel
  ThemeData getTheme() {
    if (_isDarkMode) {
      return _darkTheme;
    } else {
      return _lightTheme;
    }
  }

  // Getter pour la propriété isDarkMode
  bool get isDarkMode => _isDarkMode;
}
