part of 'talk_manager_bloc.dart';

@immutable
abstract class TalkManagerEvent {}

class LoadChats extends TalkManagerEvent {}

class _UpdateChats extends TalkManagerEvent {
  final List<ExtendedChat> chatList;

  _UpdateChats(this.chatList);
}

class AddChat extends TalkManagerEvent {
  final String chatName;

  AddChat(this.chatName);
}
