part of 'settings_bloc.dart';

class SettingsState {
  final bool autoOpenChat;
  final List<GptToken> tokens;
  final List<int> selectedTokens;

  bool get isSelectionMode => selectedTokens.isNotEmpty;

  SettingsState copyWith({bool? autoOpenChat, List<GptToken>? tokens, List<int>? selectedTokens}) =>
      SettingsState(
          autoOpenChat: autoOpenChat ?? this.autoOpenChat,
          selectedTokens: selectedTokens ?? this.selectedTokens,
          tokens: tokens ?? this.tokens);
  SettingsState({required this.autoOpenChat, required this.tokens, required this.selectedTokens});
}
