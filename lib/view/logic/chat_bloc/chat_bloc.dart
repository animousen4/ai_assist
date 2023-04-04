import 'dart:async';

import 'package:ai_assist/model/chat/extended_chat.dart';
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

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final int chatId;
  final ChatGptService? chatGptService;
  final logger = Logger();
  late final StreamSubscription<List<Message>> messageSub;
  late final ChatGPT chatGPT;
  final MessageDatabase messageDatabase;
  ChatBloc(
      {required this.chatId,
      required this.messageDatabase,
      required this.chatGptService})
      : super(ChatState(extendedChat: null, isTemplate: null)) {
    chatGPT = ChatGPT(chatGptService: chatGptService);
    messageSub = (messageDatabase.select(messageDatabase.messages)
          ..where((tbl) => tbl.chatId.equals(chatId))
          ..where((tbl) => tbl.messageStatus.equals(0)))
        .watch()
        .listen((event) {
      add(_UpdateMessageEvent(event));
    });
    on<AddMessageEvent>((event, emit) async {

        for (var msg in event.messages) {
          await messageDatabase.into(messageDatabase.messages).insert(
              MessagesCompanion.insert(
                  messageStatus: 0,
                  chatId: chatId,
                  data: DateTime.now(),
                  role: msg.role.name,
                  content: msg.content));
        }

        if ((await (messageDatabase.select(messageDatabase.chats)
                      ..where((tbl) => tbl.chatId.equals(chatId)))
                    .getSingle())
                .chatType ==
            0) {
          emit(state.copyWith(msgStatus: MsgStatus.sending));
          final response = await chatGPT.sendUnsavedMessages(
              (await (messageDatabase.select(messageDatabase.messages)
                        ..where((tbl) => tbl.messageStatus.equals(0))
                        ..where((tbl) => tbl.chatId.equals(chatId)))
                      .get())
                  .map<ExtendedMessage>((e) => ExtendedMessage.fromMessage(e))
                  .toList());
          for (var msg in response) {
            await messageDatabase.into(messageDatabase.messages).insert(
                MessagesCompanion.insert(
                    messageStatus: 0,
                    chatId: chatId,
                    data: DateTime.now(),
                    role: msg.role.name,
                    content: msg.content));
          }
          emit(state.copyWith(msgStatus: MsgStatus.ok));
        }
      
    });

    on<_ReceiveError>((event, emit) {
      emit(state.copyWith(error: () => event.error.toString()));
    });
    on<ClearError>((event, emit) {
      emit(state.copyWith(error: () => null));
    });
    on<_InitTemplateStatus>((event, emit) {});
    on<_UpdateMessageEvent>((event, emit) async {
      final chat = (await (messageDatabase.select(messageDatabase.chats)
            ..where((tbl) => tbl.chatId.equals(chatId)))
          .getSingle());
      emit(
        state.copyWith(
            isTemplate: chat.chatType == 1,
            extendedChat: ExtendedChat(
                chatId: chatId, name: chat.chatName, messages: event.messages),
            msgStatus: MsgStatus.ok),
      );
    });
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
