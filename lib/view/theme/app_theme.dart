import 'package:ai_assist/view/theme/message_bubble_theme.dart';
import 'package:flutter/material.dart';

class AppThemeManager {
  static ThemeData get dark => ThemeData.dark(useMaterial3: true).copyWith(
          extensions: [
            MessageBubbleTheme(
                topperCodeColor: Color.fromARGB(255, 75, 81, 83),
                textHighlightColor: Colors.green[400],
                messageColor: Colors.grey[800],
                textColor: Colors.white)
          ],
          inputDecorationTheme: InputDecorationTheme(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

  static ThemeData get light => ThemeData.light(useMaterial3: true).copyWith(
        extensions: [
          MessageBubbleTheme(
              topperCodeColor: Color.fromARGB(255, 115, 124, 127),
              textHighlightColor: Color.fromARGB(255, 122, 102, 187),
              messageColor: Color.fromARGB(255, 233, 233, 233),
              textColor: const Color.fromARGB(255, 39, 39, 39))
        ],
      );

  static List<ThemeData> get allThemes => [dark, light];
}
