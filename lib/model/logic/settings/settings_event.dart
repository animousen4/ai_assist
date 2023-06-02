part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}

class ReloadSettings extends SettingsEvent {
  final List<GptToken> tokens;

  ReloadSettings(this.tokens);
}

class ChangeAutoChatStatus extends SettingsEvent {
  final bool newStatus;

  ChangeAutoChatStatus(this.newStatus);
}

class AddKey extends SettingsEvent {
  final String key;

  AddKey(this.key);
}

class RefreshToken extends SettingsEvent {
  final int id;

  RefreshToken(this.id);
}
