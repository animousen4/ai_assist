part of 'settings_bloc.dart';


class SettingsState {
  bool? autoOpenChat;
  List<GptToken> tokens;

  SettingsState copyWith({bool? autoOpenChat, List<GptToken>? tokens}) =>
      SettingsState(
          autoOpenChat: autoOpenChat ?? this.autoOpenChat,
          tokens: tokens ?? this.tokens);
  SettingsState({required this.autoOpenChat, required this.tokens});
}
