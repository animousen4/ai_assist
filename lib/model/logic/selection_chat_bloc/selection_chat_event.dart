part of 'selection_chat_bloc.dart';

@immutable
abstract class SelectionChatEvent {}

class SelectMessage extends SelectionChatEvent {
  final int chatId;

  SelectMessage(this.chatId);
}

class DeleteSelectedMessages extends SelectionChatEvent {}

class SwitchModificationMode extends SelectionChatEvent {}
