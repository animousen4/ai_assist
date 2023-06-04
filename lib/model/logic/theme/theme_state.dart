part of 'theme_bloc.dart';

@immutable
class ThemeState {
  final ThemeData themeData;

  final bool isDark;
  ThemeState(this.themeData, this.isDark);
}
