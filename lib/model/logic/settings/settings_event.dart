part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}

class SelectItem extends SettingsEvent {
  final int id;

  SelectItem(this.id);
}


class SelectSyntaxTheme extends SettingsEvent {
  final int index;

  SelectSyntaxTheme(this.index);
}

class DeleteSelectedKeys extends SettingsEvent {}

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

class RefreshAllTokens extends SettingsEvent {}

class RefreshToken extends SettingsEvent {
  final int id;

  RefreshToken(this.id);
}
