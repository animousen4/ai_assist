part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class MessageEvent extends ChatEvent {
  final List<MessageAdapter> messages;

  MessageEvent(this.messages);
}

class IndexedMessageEvent extends ChatEvent {
  final int index;

  IndexedMessageEvent(this.index);
}

class ModifyMessageEvent extends IndexedMessageEvent {
  final GptMessage? message;
  ModifyMessageEvent(super.index, {this.message});
}

class _ReceiveError extends ChatEvent {
  final Object error;

  _ReceiveError(this.error);
}

class AddMessageEvent extends MessageEvent {
  AddMessageEvent(super.messages);
}

class _UpdateMessageEvent extends ChatEvent {
  final List<ExtendedMessage> messages;
  _UpdateMessageEvent(this.messages);
}

class _RecieveMessage extends MessageEvent {
  _RecieveMessage(super.messages);
}
