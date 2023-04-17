import 'dart:math';

import 'package:ai_assist/model/db/c/message_db.dart';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:meta/meta.dart';

import '../../../model/db/abstract_message_db.dart';

part 'selection_event.dart';
part 'selection_state.dart';

class SelectionBloc extends Bloc<SelectionEvent, SelectionState> {
  final MessageDatabase messageDatabase;
  SelectionBloc({required this.messageDatabase})
      : super(SelectionState(selectedChatIds: [])) {
    on<SelectChat>((event, emit) {
      if (state.selectedChatIds.contains(event.chatId)) {
        emit(state.copyWith(
            selectedChatIds: state.selectedChatIds..remove(event.chatId)));
      } else {
        emit(state.copyWith(
            selectedChatIds: state.selectedChatIds..add(event.chatId)));
      }
    });

    on<DeleteChats>((event, emit) async {
      await (messageDatabase.update(messageDatabase.chats)
            ..where((tbl) => tbl.chatId.isIn(state.selectedChatIds)))
          .write(ChatsCompanion(chatStatus: Value(1)));
      emit(state.copyWith(selectedChatIds: []));
    });

    on<MakeCopy>((event, emit) async {
      for (var chatId in state.selectedChatIds) {
        var newChatId = await messageDatabase
            .into(messageDatabase.chats)
            .insert(ChatsCompanion.insert(
                chatStatus: 0,
                chatType: event.targetChatType ?? 0,
                chatName: (await (messageDatabase.select(messageDatabase.chats)
                          ..where((tbl) => tbl.chatId.equals(chatId)))
                        .getSingle())
                    .chatName,
                creationDate: DateTime.now()));

        var oldMessages =
            await (messageDatabase.select(messageDatabase.messages)
                  ..where((tbl) => tbl.chatId.equals(chatId)))
                .get();
        for (var oldMsg in oldMessages) {
          await messageDatabase.into(messageDatabase.messages).insert(
              MessagesCompanion.insert(
                  messageStatus: 0,
                  chatId: newChatId,
                  data: oldMsg.data,
                  role: oldMsg.role,
                  content: oldMsg.content));
        }
      }
      emit(state.copyWith(selectedChatIds: []));
    });

    on<MakeCopyToTemplates>((event, emit) {
      add(MakeCopy(targetChatType: 1));
    });

    on<Rename>((event, emit) async {
      await (messageDatabase.update(messageDatabase.chats)
            ..where((tbl) => tbl.chatId.equals(state.selectedChatIds.first)))
          .write(ChatsCompanion(chatName: Value(event.newName)));
      emit(state.copyWith(selectedChatIds: []));
    });
  }
}
