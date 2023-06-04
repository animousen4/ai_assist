part of 'talk_manager_bloc.dart';

class TalkManagerState {
  final List<ExtendedChat> chats;
  final int? toOpenChatId;
  TalkManagerState(this.chats, {this.toOpenChatId});

  TalkManagerState copyWith(
      {List<ExtendedChat>? chats, int? toOpenChatId, int? toOpenChat}) {
    return TalkManagerState(
      chats ?? this.chats,
      toOpenChatId: toOpenChatId ?? this.toOpenChatId,
    );
  }
}
