import 'dart:async';
import 'dart:math';

import 'package:ai_assist/model/chat/extended_chat.dart';
import 'package:ai_assist/model/db/abstract_message_db.dart';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:gpt_api/gpt_api.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/chat/extended_message.dart';

part 'talk_manager_event.dart';
part 'talk_manager_state.dart';

class TalkManagerBloc extends Bloc<TalkManagerEvent, TalkManagerState> {
  final bool isTempl;
  final AbstractMessageDatabase messageDatabase;
  late final StreamSubscription<List<Message>> messageSub;
  late final StreamSubscription<List<Chat>> chatSub;
  int get getChatType => isTempl ? 1 : 0;
  TalkManagerBloc({required this.isTempl, required this.messageDatabase})
      : super(TalkManagerState([])) {
    messageSub = (messageDatabase.select(messageDatabase.messages)
          ..where((tbl) => tbl.messageStatus.equals(0))
          ..orderBy([
            (u) => OrderingTerm(expression: u.data, mode: OrderingMode.desc)
          ]))
        .watch()
        .listen(
      (messageList) async {
        add(_UpdateChats(await collectChats(messageList)));
      },
    );

    chatSub = ((messageDatabase.select(messageDatabase.chats))
        .watch()
        .listen((chatList) async {
      add(_UpdateChats(await collectChats(await (messageDatabase
              .select(messageDatabase.messages)
            ..orderBy([
              (u) => OrderingTerm(expression: u.data, mode: OrderingMode.desc)
            ])
            ..where((tbl) => tbl.messageStatus.equals(0))
            )
            
          .get())));
    }));

    on<AddChat>((event, emit) async {
      //messageDatabase.into(messageDatabase.messages).insert(MessagesCompanion.insert(chatId: chatId, data: data, role: role, content: content))

      await messageDatabase.into(messageDatabase.chats).insert(
          ChatsCompanion.insert(
              chatType: getChatType,
              chatName: event.chatName,
              chatStatus: 0,
              creationDate: DateTime.now()));

      //messageStream.publish()
    });

    on<TalkManagerEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<_UpdateChats>((event, emit) {
      emit(TalkManagerState(event.chatList));
    });
    on<LoadChats>((event, emit) {});
  }

  Future<List<ExtendedChat>> collectChats(List<Message> messageList) async {
    Map<int, ExtendedChat> m = {};
    for (var msg in messageList) {
      Chat? chat = await (messageDatabase.select(messageDatabase.chats)
            ..where((tbl) => tbl.chatId.equals(msg.chatId))
            ..where((tbl) => tbl.chatType.equals(getChatType))
            ..where((tbl) => tbl.chatStatus.equals(0)))
          .getSingleOrNull();
      if (chat != null) {
        m.putIfAbsent(msg.chatId, () => ExtendedChat.fromChat(chat, [msg]));
      }
    }
    var chats = await (messageDatabase.select(messageDatabase.chats)
          ..where((tbl) => tbl.chatType.equals(getChatType))
          ..where((tbl) => tbl.chatStatus.equals(0)))
        .get();
    for (var leftChat in chats) {
      m.putIfAbsent(leftChat.chatId, () => ExtendedChat.fromChat(leftChat, []));
    }

    return m.values.toList();
  }

  @override
  Future<void> close() {
    messageSub.cancel();
    return super.close();
  }
}
