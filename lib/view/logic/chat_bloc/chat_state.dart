part of 'chat_bloc.dart';

enum ChatStatus { processing, ok, error }

class ChatReady {
  final ChatStatus chatStatus;
  final bool isTemplate;
  final List<ExtendedMessage> messages;
  ChatReady({required this.messages, required this.chatStatus, required this.isTemplate});

  ChatReady copyWith({List<ExtendedMessage>? messages, ChatStatus? chatStatus, bool? isTemplate}) =>
      ChatReady(
          messages: messages ?? this.messages,
          isTemplate: isTemplate ?? this.isTemplate,
          chatStatus: chatStatus ?? this.chatStatus);
}
