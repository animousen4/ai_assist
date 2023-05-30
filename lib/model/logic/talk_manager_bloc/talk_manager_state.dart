part of 'talk_manager_bloc.dart';

class TalkManagerState {
  final List<ExtendedChat> chats;
  final int? defaultChatId;
  TalkManagerState(this.chats, {this.defaultChatId});

  TalkManagerState copyWith({List<ExtendedChat>? chats, int? defaultChatId}) {
    return TalkManagerState(chats ?? this.chats, defaultChatId: defaultChatId ?? this.defaultChatId);
  }
}
