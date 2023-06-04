part of 'settings_bloc.dart';

class SettingsState {
  final bool autoOpenChat;
  final List<GptToken> tokens;
  final List<int> selectedTokens;

  final int codeViewThemeIndex;
  bool get isSelectionMode => selectedTokens.isNotEmpty;

  SettingsState copyWith(
          {bool? autoOpenChat,
          List<GptToken>? tokens,
          List<int>? selectedTokens,
          int? codeViewThemeIndex}) =>
      SettingsState(
          autoOpenChat: autoOpenChat ?? this.autoOpenChat,
          selectedTokens: selectedTokens ?? this.selectedTokens,
          codeViewThemeIndex: codeViewThemeIndex ?? this.codeViewThemeIndex,
          tokens: tokens ?? this.tokens);
  SettingsState(
      {required this.autoOpenChat,
      required this.tokens,
      required this.selectedTokens,
      required this.codeViewThemeIndex});
}
