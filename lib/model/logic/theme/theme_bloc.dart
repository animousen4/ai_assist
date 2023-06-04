import 'package:ai_assist/view/theme/app_theme.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

const String themeIdKey = "themeId";

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences sharedPreferences;
  final logger = Logger();
  ThemeBloc(this.sharedPreferences)
      : super(ThemeState(AppThemeManager
            .allThemes[sharedPreferences.getInt(themeIdKey) ?? 0], true)) {
    on<ChangeTheme>((event, emit) async {
      logger.d("Changing theme to ${event.isDark}");
      await sharedPreferences.setInt(themeIdKey, event.isDark ? 0 : 1);
      logger.d(sharedPreferences.getInt(themeIdKey));
      emit(ThemeState(AppThemeManager
          .allThemes[sharedPreferences.getInt(themeIdKey) ?? 0], event.isDark));
    });
  }
}
