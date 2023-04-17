part of 'chat_bloc.dart';

enum ChatStatus { loading, ok, error }

enum MsgStatus { sending, sent, ok, error }

class ChatState {
  final ExtendedChat? extendedChat;
  final String? error;
  final MsgStatus? msgStatus;
  final bool? isTemplate;
  ChatState(
      {required this.extendedChat, required this.isTemplate, this.msgStatus, this.error});

  ChatState copyWith(
          {ExtendedChat? extendedChat,
          MsgStatus? msgStatus,
          bool? isTemplate,
          String? Function()? error}) =>
      ChatState(
        extendedChat: extendedChat ?? this.extendedChat,
        isTemplate: isTemplate ?? this.isTemplate,
        msgStatus: msgStatus ?? this.msgStatus,
        error: error != null ? error() : this.error 
      );
}
