import 'dart:async';

import 'package:ai_assist/model/chat/extended_message.dart';
import 'package:ai_assist/model/db/abstract_message_db.dart';
import 'package:ai_assist/model/db/c/message_db.dart';
import 'package:ai_assist/view/logic/impl/addable.dart';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:gpt_api/gpt_api.dart';
import 'package:rxdart/rxdart.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatReady> {
  final int chatId;
  final logger = Logger();
  late final StreamSubscription<List<Message>> messageSub;
  final MessageDatabase messageDatabase;
  ChatBloc({
    required this.chatId,
    required this.messageDatabase,
  }) : super(ChatReady(
            messages: [], chatStatus: ChatStatus.ok, isTemplate: false)) {
    messageSub = (messageDatabase.select(messageDatabase.messages)
          ..where((tbl) => tbl.chatId.equals(chatId)))
        .watch()
        .listen((event) {
      add(_UpdateMessageEvent(event
          .map<ExtendedMessage>((e) => ExtendedMessage(
              date: e.data,
              content: e.content,
              role: ChatGptRole.valueOf(e.role)))
          .toList()));
    });
    on<AddMessageEvent>((event, emit) {
      for (var msg in event.messages) {
        messageDatabase.into(messageDatabase.messages).insert(
            MessagesCompanion.insert(
                chatId: chatId,
                data: DateTime.now(),
                role: msg.role.name,
                content: msg.content));
      }
    });

    on<_UpdateMessageEvent>((event, emit) {
      emit(state.copyWith(messages: event.messages));
    });
    // extendedMessages = [];
    // on<AddMessageEvent>((event, emit) async {
    //   extendedMessages.add(ExtendedMessage(
    //       date: DateTime.now(),
    //       content: event.messages.first.content,
    //       role: event.messages.first.role));
    //   emit(ChatReady(
    //       messages: extendedMessages,
    //       chatStatus: ChatStatus.processing,
    //       isTemplate: isTemplate));

    //   await chatGPT?.sendUnsavedMessages(extendedMessages);
    //   emit(ChatReady(
    //       messages: extendedMessages,
    //       chatStatus: ChatStatus.ok,
    //       isTemplate: isTemplate));
    // });

    // on<_ReceiveError>((event, emit) {
    //   emit(ChatReady(
    //       messages: extendedMessages,
    //       chatStatus: ChatStatus.error,
    //       isTemplate: isTemplate));
    // });
    // on<_RecieveMessage>((event, emit) {});
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    add(_ReceiveError(error));
    super.onError(error, stackTrace);
  }

  @override
  Future<void> close() {
    logger.i("CLOSE");
    messageSub.cancel();
    return super.close();
  }
}
