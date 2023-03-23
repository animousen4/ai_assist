import 'package:flutter/material.dart';

class AppThemeManager {
  static ThemeData get dark => ThemeData.dark(useMaterial3: true).copyWith(
      extensions: [],
      inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
}
